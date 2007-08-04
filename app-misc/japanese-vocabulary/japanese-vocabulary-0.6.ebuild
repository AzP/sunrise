# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 toolchain-funcs

KEYWORDS="~x86"

MY_PN=JapaneseVocabulary

DESCRIPTION="A simple vocabulary program for studying Japanese."
HOMEPAGE="http://code.google.com/p/japanese-vocabulary/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_PN}-${PV}-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="$(qt4_min_version 4.2)"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use =x11-libs/qt-4* sqlite3 ; then
		eerror "Qt4 has to be built with sqlite3 support"
		die "Missing sqlite3 USE-flag for x11-libs/qt-4"
	fi
}

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	dobin ${MY_PN}
	keepdir /usr/share/${PN}
}

pkg_postinst() {
	elog "To fetch an up-to-date vocabulary file, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
}

pkg_config() {
	cd ${ROOT}usr/share/${PN}
	wget "http://japanese-vocabulary.googlecode.com/files/jlpt.vocab"
	einfo "The vocabulary database is in:"
	einfo "  /usr/share/${PN}"
}

pkg_postrm() {
	# do not leave orphaned cruft behind
	[[ -e ${ROOT}/usr/share/${PN} ]] && rm -rf /usr/share/${PN}
}
