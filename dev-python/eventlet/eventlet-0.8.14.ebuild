# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils

DESCRIPTION="A networking library that achieves high scalability by using non-blocking io"
HOMEPAGE="http://wiki.secondlife.com/wiki/Eventlet"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND="dev-lang/python
	dev-python/greenlet
	dev-python/pyopenssl"
DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( || ( dev-lang/python[sqlite] dev-python/pysqlite ) )"

src_prepare() {
	epatch "${FILESDIR}/remove-assert-parenthesis.patch"
}

src_test() {
	cd greentest
	PYTHONPATH=.. ${python} runall.py || die "Tests failed"
}

src_install() {
	distutils_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "Install failed"
	fi;
}