# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Kirill A. Korinskiy <catap@catap.ru>
# $Header: /var/cvsroot/gentoo-x86/dev-util/tla-tools/tla-tools-20060509.ebuild,v 1.3 2006/04/29 05:07:25 mkennedy Exp $

inherit tla

DESCRIPTION="tla-tools is a package of helpful commands to use with the tla program."
HOMEPAGE="http://www.gnuarch.org/gnuarchwiki/tla-tools"
SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="~x86"
DEPEND="dev-util/tla"

ETLA_VERSION="miles@gnu.org--2006/tla-tools--devo--0"
ETLA_ARCHIVES="http://mirrors.sourcecontrol.net/miles@gnu.org--2006"

src_compile() {
	./configure \
		--prefix /usr || die "./configure failed"
	emake || die "make failed"
}

src_install () {
	emake DESTDIR=${D} install || die "make install failed"
}
