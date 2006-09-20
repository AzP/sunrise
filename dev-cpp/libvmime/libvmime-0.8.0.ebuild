# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

KEYWORDS="~x86"

DESCRIPTION="A powerful C++ class library for working with MIME messages and Internet messaging services like IMAP, POP or SMTP."
HOMEPAGE="http://www.vmime.org/"
SRC_URI="mirror://sourceforge/vmime/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc sasl ssl"

CDEPEND="sasl? ( net-libs/libgsasl )
		ssl? ( net-libs/gnutls )
		virtual/libiconv"
DEPEND="${CDEPEND}
		doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gnutls_ssl-detection.patch"
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable sasl) \
		$(use_enable ssl tls) \
		--enable-platform-posix \
		--enable-messaging \
		--enable-messaging-proto-pop3 \
		--enable-messaging-proto-smtp \
		--enable-messaging-proto-imap \
		--enable-messaging-proto-maildir \
		--enable-messaging-proto-sendmail \
		|| die "econf failed"
	emake || die "emake failed"
	if use doc ; then
		doxygen vmime.doxygen || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use doc ; then
		dohtml doc/html/*
	fi
	insinto /usr/share/${PN}
	doins -r examples

}
