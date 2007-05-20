# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="DevKitPro toolchain for ARM processors"
HOMEPAGE="http://devkitpro.org/"
SRC_URI="mirror://sourceforge/devkitpro/devkitARM_r${PV}-linux.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/devkitARM"
RESTRICT="strip"

dir=/opt/devkitpro/devkitARM

QA_EXECSTACK="${dir:1}/lib/gcc/arm-eabi/4.1.1/thumb/*.o
	${dir:1}/lib/gcc/arm-eabi/4.1.1/*.o
	${dir:1}/arm-eabi/lib/*.o"

src_install() {
	local DEVKITPRO=/opt/devkitpro
	local INSTDIR=${DEVKITPRO}/devkitARM

	insinto ${INSTDIR}
	insopts -m0755
	doins -r *

	doenvd ${FILESDIR}/99devkitpro
}

