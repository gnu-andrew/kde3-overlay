# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kword/kword-1.6.3_p20090204.ebuild,v 1.11 2009/09/27 12:37:20 ranger Exp $

ARTS_REQUIRED="never"

KMNAME=koffice
inherit kde-meta eutils subversion

DESCRIPTION="KOffice word processor."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/branches/koffice/1.6/koffice"
ESVN_PROJECT="koffice"

SLOT="3.5"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="~app-office/koffice-libs-1.6.9999
	~app-office/kspread-1.6.9999
	>=app-text/wv2-0.1.8
	>=media-gfx/imagemagick-5.5.2
	>=app-text/libwpd-0.8.2"
RDEPEND="${DEPEND}"

KMCOPYLIB="libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkspreadcommon kspread"

KMEXTRACTONLY="
	lib/
	kspread/"

KMCOMPILEONLY="filters/liboofilter"

KMEXTRA="filters/kword"

need-kde 3.5

PATCHES=( "${FILESDIR}/${PN}-1.6.3-gcc44.patch" )

src_unpack() {
	subversion_src_unpack
	kde-meta_src_unpack unpack

	# work with new wv2 API: http://wvware.svn.sourceforge.net/viewvc/wvware?view=rev&revision=33
	if has_version ">=app-text/wv2-0.4.2"; then
		epatch "${FILESDIR}/wv2.patch"
	fi

	# We need to compile libs first
	echo "SUBDIRS = liboofilter kword" > "${S}"/filters/Makefile.am
	for i in $(find "${S}"/lib -iname "*\.ui"); do
		"${QTDIR}"/bin/uic ${i} > ${i%.ui}.h
	done

	# Remove unneeded directories
	for dirs in kexi kdgantt kchart karbon kformula kivio koshell kounavail kplato kpresenter krita kugar; do
		einfo "Removing ${dirs}..."
		rm -rf "${S}"/"${dirs}"
	done

	kde-meta_src_unpack makefiles

}
