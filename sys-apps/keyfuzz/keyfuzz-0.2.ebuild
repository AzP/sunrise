# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utility for manipulating the scancode/keycode translation tables of
keyboard drivers"
HOMEPAGE="http://0pointer.de/lennart/projects/keyfuzz/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dobin src/keyfuzz
	dodoc README LICENSE
	doman man/*
}
