# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Easy installation of Gentoo overlays"

HOMEPAGE="http://git.goodpoint.de/?p=layman-add.git;a=summary"
SRC_URI="http://www.hartwork.org/public/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-portage/layman"
DEPEND=${RDEPEND}

src_install() {
	dobin layman-add || die "dobin failed"
}
