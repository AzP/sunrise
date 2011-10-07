# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="System utilities for UnionFS"
HOMEPAGE="http://www.fsl.cs.sunysb.edu/project-unionfs.html"
SRC_URI="ftp://ftp.fsl.cs.sunysb.edu/pub/unionfs/${PN}-0.x/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${P/-/_}"

src_compile() {
	# --enable-static for this package is for libraries only.
	# livecd and initrd want these in /sbin static or not,
	# whereas the package puts them in /usr/bin.
	econf --bindir=/sbin --sbindir=/sbin
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS README || die "dodoc failed"
}
