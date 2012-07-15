# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koffice-data/koffice-data-1.6.3_p20090204.ebuild,v 1.8 2009/09/27 12:32:27 ranger Exp $

EAPI=0
ARTS_REQUIRED="never"

KMNAME=koffice
KMMODULE=
inherit kde-meta eutils subversion

DESCRIPTION="Shared KOffice data files."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/branches/koffice/1.6/koffice"
ESVN_PROJECT="koffice"
SRC_URI=""

SLOT="3.5"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

KMEXTRA="
	mimetypes/
	servicetypes/
	pics/
	templates/
	autocorrect/"

need-kde 3.5

src_unpack() {
	subversion_src_unpack
	kde-meta_src_unpack unpack

	# Remove unneeded directories
	for dirs in kdgantt kspread karbon kformula kivio koshell kounavail kplato kpresenter krita kugar kword kchart filters \
	 kexi lib interfaces plugins tools ; do
		einfo "Removing ${dirs}..."
		rm -rf "${S}"/"${dirs}"
	done

	kde-meta_src_unpack makefiles
}
