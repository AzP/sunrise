# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zproduct

MY_PN="Relations"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Relations allows for component-wise control of validation, creation and lifetime of Archetypes references."
HOMEPAGE="http://plone.org/products/relations/"
SRC_URI="http://plone.org/products/relations/releases/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="net-zope/archetypes"

ZPROD_LIST="$MY_PN"
