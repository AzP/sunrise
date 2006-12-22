# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GTK+ 2 rewrite of LinNeighborhood"
HOMEPAGE="http://pyneighborhood.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyneighborhood/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
REPEND="net-fs/samba
	=dev-python/pygtk-2*"

src_compile() {
	./configure --prefix=/usr || die "./configure failed" # Not a standard configure script
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
