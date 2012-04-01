# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils webapp

DESCRIPTION="A lighweight system monitoring tool"
HOMEPAGE="http://www.monitorix.org/"
SRC_URI="http://www.monitorix.org/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="evms hddtemp lm_sensors"

DEPEND="sys-apps/sed"
RDEPEND="net-analyzer/rrdtool[perl]
	net-mail/metamail
	dev-perl/libwww-perl
	evms? ( sys-fs/evms )
	hddtemp? ( app-admin/hddtemp )
	lm_sensors? ( sys-apps/lm_sensors )
	|| ( sys-process/bcron
		sys-process/cronie
		sys-process/dcron
		sys-process/fcron
		sys-process/vixie-cron )"

need_httpd_cgi

src_prepare() {
	sed -i -e "s|\(our \$OSTYPE = \"Linux-\)RHFC|\1Gentoo|" ${PN}.conf \
		   || die "sed failed"
}

src_install() {
	webapp_src_preinst

	dosbin ${PN}.pl || die "dosbin failed"

	newinitd ports/Linux-Gentoo/${PN}.init ${PN} || die "newinitd failed"

	insinto /etc
	doins ${PN}.conf || die "doins failed"

	dodoc Changes ${PN}-apache.conf README{,.nginx} TODO \
		${PN}-alert.sh || die "dodoc failed"
	doman man/man5/${PN}.conf.5 || die "doman failed"

	insinto "${MY_HTDOCSDIR}"
	doins logo_bot.png logo_top.png monitorixico.png || die "doins failed"
	dodir "${MY_HTDOCSDIR}/imgs" || die "dodir failed"
	webapp_serverowned "${MY_HTDOCSDIR}/imgs"

	exeinto ${MY_CGIBINDIR}
	doexe ${PN}.cgi || die "doexe failed"

	dodir /var/lib/${PN}/usage || die "dodir failed"
	insinto /var/lib/${PN}/reports
	doins -r reports/* || die "doins failed"
	webapp_src_install
}

pkg_postinst() {
	elog "Before starting the ${PN} init script make sure you edited the "
	elog "config file. After that you can start ${PN} by running"
	elog "\t/etc/init.d/${PN} start"
	elog "If you want to start it automatically on boot run"
	elog "\trc-update add ${PN} default"
	elog
	elog "This package is run via /etc/cron.d and therefore uses root "
	elog "privileges to collect the informations. The graphs are created "
	elog "at runtime directly to the imgs/ directory inside the dir you "
	elog "installed the app to with webapp-config. These are created "
	elog "with the privileges of the webserver user account."
	elog
	elog "If you want to use the alert function (introduced in ${PN}-1.4.0), you "
	elog "need to enable it in the config and provide a path to a script "
	elog "which should be run in an alert case. An example script is provided "
	elog "with this package."
	elog
	elog "If you don't use sendmail be sure to set 'ENABLE_MAIL' to 'N' in the"
	elog "config file."

	webapp_pkg_postinst
}
