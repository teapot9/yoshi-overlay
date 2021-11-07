# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Man-pages created by hands following online API document"
HOMEPAGE="https://github.com/haxpor/sdl2-manpage"
SRC_URI="https://github.com/haxpor/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
