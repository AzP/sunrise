# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5
PYTHON_MODNAME="cvxopt"

EAPI="2"

inherit distutils

DESCRIPTION="A Python Package for Convex Optimization"
HOMEPAGE="http://abel.ee.ucla.edu/cvxopt"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fftw glpk gsl"

DEPEND="virtual/blas
	virtual/lapack
	virtual/cblas
	fftw? ( sci-libs/fftw )
	glpk? ( sci-mathematics/glpk )
	gsl? ( sci-libs/gsl )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare(){
	use gsl && sed -i s/"BUILD_GSL = 0"/"BUILD_GSL = 1"/ setup.py
	use fftw && sed -i s/"BUILD_FFTW = 0"/"BUILD_FFTW = 1"/ setup.py
	use glpk && sed -i s/"BUILD_GLPK = 0"/"BUILD_GLPK = 1"/ setup.py
}
