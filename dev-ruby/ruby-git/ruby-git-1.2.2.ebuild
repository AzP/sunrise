# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"
inherit gems

DESCRIPTION="Git Library for Ruby"
HOMEPAGE="http://github.com/schacon/ruby-git/"
SRC_URI="mirror://rubygems/git-${PV}.gem -> ${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}"
