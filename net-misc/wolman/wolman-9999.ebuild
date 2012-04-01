# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4-r2 subversion eutils

QT4_BUILT_WITH_USE_CHECK="png"

ESVN_REPO_URI="svn://svn.dolezel.info/${PN}/trunk/${PN}"
DESCRIPTION="GUI Wake-on-LAN manager"
HOMEPAGE="http://www.dolezel.info/projects/wolman"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-gui:4
	net-libs/libnet
	net-libs/libpcap"
RDEPEND="${DEPEND}
	sys-apps/iproute2"

S="${WORKDIR}/${PN}"

src_install() {
	dosbin wolman || die "dosbin failed"
	newicon gfx/green.png ${PN}.png
	make_desktop_entry ${PN} "Wake-on-LAN manager" ${PN} "Network;RemoteAccess;Qt" /usr/sbin
}
