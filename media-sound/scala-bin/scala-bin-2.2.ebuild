# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fdo-mime gnome2-utils versionator

MY_PV=$(delete_all_version_separators ${PV})
MY_P="${PN/-bin}-${MY_PV}-pc-linux"

DESCRIPTION="Powerful software tool to experiment with musical tunings"
HOMEPAGE="http://www.huygens-fokker.org/scala/"
SRC_URI="http://www.huygens-fokker.org/software/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="midi"

RDEPEND="=virtual/gnat-4.1*
	>=dev-ada/gtkada-2.8.0
	midi? ( media-sound/playmidi )"

RESTRICT="mirror strip test"
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -f libgtkada-2.8.so.0 || die "cannot delete bundled gtkada"
}

src_install() {
	for i in html xpm ; do
		insinto /opt/${PN}/${i}
		doins ${i}/* || die "doins failed"
	done

	insinto /opt/${PN}
	doins *.{clv,gif,htm,html,kbm,par,scl,seq} scala.{ini,ico} scalarc || die "doins failed"

	exeinto /opt/${PN}/cmd
	doexe cmd/* || die "doexe failed"
	exeinto /opt/${PN}
	doexe *.cmd || die "doexe failed"

	doexe scala || die "failed to install main binary"
	dosym /opt/${PN}/scala /opt/bin/scala
	doicon "${FILESDIR}"/${PN}.png || die
	make_desktop_entry scala Scala ${PN} \
		'AudioVideo;Audio;GNOME;GTK;Midi;Music'	Path=/opt/${PN}

	dodoc cmdlist.txt commands.txt dummies.txt first.txt readme.txt || die

	echo 'SCALA_HOME="/opt/scala-bin"' > "${T}"/99${PN}
	doenvd "${T}"/99${PN} || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	elog "A collection of over 3600 scales can be downloaded from"
	elog "	http://www.huygens-fokker.org/docs/scales.zip"
	elog "Unpack them to /opt/${PN}/scl directory using unzip -a scales.zip command."
	elog
	elog "NOTE: The -a option is important! The files cannot be opened if"
	elog "NOTE: they are unzipped on Linux without this option!"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	if [[ -d ${ROOT}/opt/${PN}/scl ]] ; then
		elog "Seems that you have installed custom scales to ${ROOT}/opt/${PN}/scl"
		elog "You will have to delete this directory manually."
	fi
}
