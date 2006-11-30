# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Kommando is a \"Neverwinter Nights\" like wheelmenu for KDE."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=29514"
SRC_URI="http://www.kde-apps.org/content/files/29514-${P}.tar.bz2"

KEYWORDS="~x86"

SLOT="0"
LICENSE="GPL-2"
IUSE="kdeenablefinal"

DEPEND=""
RDEPEND="${DEPEND}"

need-kde 3.5
