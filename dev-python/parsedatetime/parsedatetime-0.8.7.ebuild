# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Parse human-readable date/time expressions"
HOMEPAGE="http://code-bear.com/code/parsedatetime/ http://code.google.com/p/parsedatetime/"
SRC_URI="http://code-bear.com/code/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( dev-python/epydoc )"
RDEPEND="dev-python/pyicu"

DOCS="THANKS.txt AUTHORS.txt CHANGES.txt"

src_prepare() {
	# A broken and unnecessary test script made it into the release. delete it.
	if [[ -f "${S}/${PN}/t2.py" ]]; then
		rm -f "${S}/${PN}/t2.py" || die "Removing t2.py failed!"
	fi
}

src_compile() {
	if use doc; then
		epydoc --config epydoc.conf || die "Couldn't generate docs"
	fi
	distutils_src_compile
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" run_tests.py
	}
	python_execute_function testing
}

src_install() {
	if use doc; then
		dohtml -r docs/* || die "Installing the docs failed!"
	fi
	distutils_src_install
}
