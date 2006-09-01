# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

MY_P=${P/ruby-mpd/mpd-rb}

DESCRIPTION="Ruby class for communicating with an MPD server"
HOMEPAGE="http://www.andsoforth.com/geek/mpd_rb.html"
SRC_URI="http://www.andsoforth.com/downloads/mpd-rb/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="|| ( media-sound/mpd media-sound/mpd-svn )"

S=${WORKDIR}/${MY_P}
