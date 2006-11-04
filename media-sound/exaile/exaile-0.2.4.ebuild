# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

MY_P=${PN}_${PV}

DESCRIPTION="Exaile is a media player aiming to be similar to KDE's AmaroK, but for GTK"
HOMEPAGE="http://www.exaile.org/"
SRC_URI="http://www.exaile.org/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="fam mp3 trayicon ipod"

DEPEND=">=dev-lang/python-2.4
		>=dev-python/pygtk-2.0"
RDEPEND="${DEPEND}
		>=dev-python/pysqlite-2
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-good-0.10
		>=dev-python/gst-python-0.10
		>=media-libs/mutagen-1.6
		sys-apps/dbus
		fam? ( app-admin/gamin )
		mp3? ( >=media-plugins/gst-plugins-mad-0.10 )
		trayicon? ( dev-python/gnome-python-extras )
		ipod? ( >=media-libs/libgpod-0.3.2-r1
				>=media-plugins/gst-plugins-faac )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! built_with_use sys-apps/dbus python; then
		eerror "dbus has to be built with python support"
		die "dbus python use-flag not set"
	fi

	if use ipod && ! built_with_use media-libs/libgpod python ; then
		eerror "libgpod has to be built with python support"
		die "libgpod python use-flag not set"
	fi

}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# We want Gentoo's mutagen package
	sed -i \
		-e '/mutagen/d' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
