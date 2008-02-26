# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="NativeThread for priorities on linux for freenet"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-p2p/freenet"

append-flags -fPIC
tc-getCC >/dev/null

pkg_setup() {
	cp ${ROOT}opt/freenet/freenet-cvs-snapshot.jar ${DISTDIR}/
	chmod 644 ${DISTDIR}/freenet-cvs-snapshot.jar
}


src_unpack() {
	unpack ${A}
	cp ${DISTDIR}/freenet-cvs-snapshot.jar .
	epatch "${FILESDIR}"/Makefile.patch
}

src_install() {
	into /opt/freenet
	dolib.so libNativeThread.so
}
