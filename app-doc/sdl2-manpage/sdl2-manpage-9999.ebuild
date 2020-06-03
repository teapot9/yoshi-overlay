# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Man-pages generated for SDL2"
HOMEPAGE="https://github.com/haxpor/sdl2-manpage"
EGIT_REPO_URI="https://github.com/haxpor/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+sdl1"

DEPEND="!sdl1? ( !media-libs/libsdl )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	if use sdl1; then
		for manpage in ./src/*.3; do
			mv "${manpage}" "${manpage/SDL/SDL2}"
		done
	fi
	doman ./src/*.3
	einstalldocs
}

