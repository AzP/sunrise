# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WEBAPP_OPTIONAL="yes"

inherit depend.php eutils perl-module toolchain-funcs webapp

DESCRIPTION="Performance and information monitoring tool"
HOMEPAGE="http://www.xs4all.nl/~wpd/symon/"
SRC_URI="http://www.xs4all.nl/~wpd/symon/philes/${P}.tar.gz
	syweb? ( http://www.xs4all.nl/~wpd/symon/philes/syweb-0.58.tar.gz )"

LICENSE="BSD-2"
WEBAPP_MANUAL_SLOT="yes"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="perl symux syweb vhosts"

RDEPEND="perl? ( dev-lang/perl )
	symux? ( net-analyzer/rrdtool )
	syweb? ( ${WEBAPP_DEPEND}
		    virtual/httpd-php )"
DEPEND="${RDEPEND}
	sys-devel/pmake"

S=${WORKDIR}/${PN}

pkg_setup() {
	if use syweb ; then
		require_php_with_any_use gd gd-external
		webapp_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${PN}-symon.conf.patch
	use symux && epatch "${FILESDIR}"/${PN}-symux.conf.patch

	if use syweb ; then
		epatch "${FILESDIR}"/${PN}-syweb-class_lexer.inc.patch
		epatch "${FILESDIR}"/${PN}-syweb-setup.inc.patch
		epatch "${FILESDIR}"/${PN}-syweb-total_firewall.layout.patch
	fi

	if ! use perl ; then
		sed -i "/SUBDIR/s/client//" "${S}"/Makefile || die "sed client failed"
	fi
	if ! use symux ; then
		sed -i "/SUBDIR/s/symux//" "${S}"/Makefile || die "sed symux failed"
	fi
}

src_compile() {
	MAKE=pmake MAKEOPTS= emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS+="${CFLAGS}" \
		RANLIB="$(tc-getRANLIB)" \
		STRIP=true || die "emake failed"
}

src_install() {
	insinto /etc
	doins symon/symon.conf || die "doins symon.conf failed"

	newinitd "${FILESDIR}"/${PN}-init.d ${PN} || die "newinitd symon failed"

	dodoc CHANGELOG HACKERS TODO || die "dodoc failed"

	doman symon/symon.8 || die "doman symon failed"
	dosbin symon/symon || die "dosbin symon failed"

	dodir /usr/share/symon
	insinto /usr/share/symon
	doins symon/c_config.sh || die "doins c_config.sh failed"
	fperms a+x,u-w /usr/share/symon/c_config.sh

	if use perl ; then
		dobin client/getsymonitem.pl || die "dobin getsymonitem.pl failed"

		perlinfo
		insinto ${SITE_LIB}
		doins client/SymuxClient.pm || die "doins SymuxClient.pm failed"
	fi

	if use symux ; then
		insinto /etc
		doins symux/symux.conf || die "doins symux.conf failed"

		newinitd "${FILESDIR}"/symux-init.d symux || die "newinitd symux failed"

		doman symux/symux.8 || die "doman symux failed"
		dosbin symux/symux || die "dosbin symux failed"

		insinto /usr/share/symon
		doins symux/c_smrrds.sh || die "doins c_smrrds.sh failed"
		fperms u-w,u+x /usr/share/symon/c_smrrds.sh

		dodir /var/lib/symon/rrds/localhost
	fi

	if use syweb ; then
		docinto layouts
		dodoc "${WORKDIR}"/syweb/symon/total_firewall.layout \
			|| die "dodoc syweb failed"

		webapp_src_preinst

		dodir "${MY_HTDOCSDIR}"/cache
		dodir "${MY_HTDOCSDIR}"/layouts
		webapp_serverowned "${MY_HTDOCSDIR}"/cache
		insinto "${MY_HTDOCSDIR}"
		doins -r "${WORKDIR}"/syweb/htdocs/syweb/* || die "doins syweb failed"
		webapp_configfile "${MY_HTDOCSDIR}"/setup.inc

		webapp_src_install
	fi
}

pkg_postinst() {
	elog "Before running the monitor, edit /etc/symon.conf. To test your"
	elog "configuration file, run symon -t."
	elog "NOTE that symon won't chroot by default."

	use perl && perl-module_pkg_postinst

	if use symux ; then
		elog "Before running the data collector, edit /etc/symux.conf."
		elog "To create the RRDs run /usr/share/symon/c_smrrds.sh all. Then,"
		elog "to test your configuration file, run symux -t."
		elog "For information about migrating RRDs from a previous symux"
		elog "version read the LEGACY FORMATS section of symux(8)."
	fi

	if use syweb ; then
		elog "Test your syweb configuration by pointing your browser at:"
		elog "http://${VHOST_HOSTNAME}/${PN}/configtest.php"
		elog "NOTE that syweb expects a machine/*.rrd style directory"
		elog "structure under /var/lib/symon/rrds."
		webapp_pkg_postinst
	fi
}

pkg_prerm() {
	use syweb && webapp_pkg_prerm
}
