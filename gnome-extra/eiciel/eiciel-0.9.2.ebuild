# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="http://rofi.pinchito.com/eiciel/"
SRC_URI="http://rofi.pinchito.com/eiciel/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls xattr"

RDEPEND=">=sys-apps/acl-2.2.32
	>=dev-cpp/gtkmm-2.8.1
	>=gnome-base/nautilus-2.12.2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_compile() {
	econf \
		$(use_enable xattr user-attributes) \
		$(use_enable nls) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Icon-path and category are wrong
	rm "${D}/usr/share/applications/eiciel.desktop"
	newicon img/icona_eiciel_32.png ${PN}.png
	make_desktop_entry ${PN} Eiciel ${PN}.png GNOME;System;Filesystem

	dodoc AUTHORS ChangeLog README
}
