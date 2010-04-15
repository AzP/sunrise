# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit kde4-base

DESCRIPTION="A simple media player for KDE"
HOMEPAGE="http://bangarangkde.wordpress.com"
SRC_URI="http://bangarangissuetracking.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/taglib"
RDEPEND="${DEPEND}
	kde-base/kdemultimedia-kioslaves"

S=${WORKDIR}/${PN}-${PN}
