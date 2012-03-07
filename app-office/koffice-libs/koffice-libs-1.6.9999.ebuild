# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koffice-libs/koffice-libs-1.6.3_p20090204.ebuild,v 1.8 2009/09/27 12:33:06 ranger Exp $

ARTS_REQUIRED="never"
EAPI="4"

KMNAME=koffice
KMMODULE=lib
inherit kde-meta eutils subversion

DESCRIPTION="Shared KOffice libraries."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/branches/koffice/1.6/koffice"
ESVN_PROJECT="koffice"
SRC_URI=""

SLOT="3.5"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="~app-office/koffice-data-1.6.9999
	dev-lang/python:2.7
	dev-lang/ruby"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

KMEXTRA="interfaces/
	plugins/
	tools/
	filters/olefilters/
	filters/xsltfilter/
	filters/generic_wrapper/
	kounavail/
	doc/koffice/
	doc/thesaurus/"

KMEXTRACTONLY="
	kchart/kdchart/"

need-kde 3.5

PATCHES=( "${FILESDIR}/const_char.patch" )

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	# work with new wv2 API: http://wvware.svn.sourceforge.net/viewvc/wvware?view=rev&revision=33
	if has_version ">=app-text/wv2-0.4.2"; then
		epatch "${FILESDIR}/wv2.patch"
	fi

	# Force the compilation of libkopainter.
	sed -i 's:$(KOPAINTERDIR):kopainter:' "${S}/lib/Makefile.am"

	if ! [[ $(xhost >> /dev/null 2>/dev/null) ]] ; then
		einfo "User ${USER} has no X access, disabling some tests."
		sed -e "s:SUBDIRS = . tests:SUBDIRS = .:" -i lib/store/Makefile.am || die "sed failed"
		sed -e "s:SUBDIRS = kohyphen . tests:SUBDIRS = kohyphen .:" -i lib/kotext/Makefile.am || die "sed failed"
	fi

	# Remove unneeded directories
	for dirs in kdgantt karbon kformula kivio koshell kplato kpresenter krita kugar kspread kword kchart; do
		einfo "Removing ${dirs}..."
		rm -rf "${S}"/"${dirs}"
	done

	kde-meta_src_unpack makefiles
}

src_configure() {
	local myconf="--enable-scripting --with-pythonfir=/usr/$(get_libdir)/python${PYVER}/site-packages"
	kde-meta_src_configure
}

src_compile() {
	kde-meta_src_compile
	if use doc; then
		make apidox || die
	fi
}

src_install() {
	kde-meta_src_install
	if use doc; then
		make DESTDIR="${D}" install-apidox || die
	fi
}
