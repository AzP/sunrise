# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${PN}-v${PV}"
DESCRIPTION="GUI frontend for Ngspice and Gnucap"
HOMEPAGE="http://www.geda.seul.org/tools/gspiceui/index.html"
SRC_URI="http://www.geda.seul.org/dist/${MY_P}.tar.gz"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="=x11-libs/wxGTK-2.6*"
RDEPEND="$DEPEND
	|| ( sci-electronics/ng-spice-rework sci-electronics/gnucap )
	sci-electronics/gwave
	sci-electronics/geda"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:CXXFLAGS =-O -pipe:CXXFLAGS +=:" \
		-e "s:WXCFG = wx-config:WXCFG = wx-config-2.6:" \
		src/Makefile \
		|| die "Patching src/Makefile failed"
	sed -i \
		-e "s:/share/gspiceui/html/gSpiceUI.html:/share/doc/${P}/html/gSpiceUI.html:" \
		src/main/HelpTasks.cpp \
		|| die "Patching src/main/HelpTasks.cpp failed"
}

src_install() {
	dobin bin/gspiceui
	dodoc AUTHORS ChangeLog README TODO
	insinto /usr/share/doc/${P}/html
	dohtml html/*.html html/*.css html/*.jpeg
	newicon src/icons/gspiceui-48x48.xpm gspiceui.xpm
	make_desktop_entry gspiceui "GNU Spice GUI" gspiceui.xpm Electronics
}
