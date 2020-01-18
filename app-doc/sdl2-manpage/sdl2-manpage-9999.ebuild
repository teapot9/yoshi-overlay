# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Man-pages generated for SDL2"
HOMEPAGE="https://github.com/haxpor/sdl2-manpage"
EGIT_REPO_URI="https://github.com/haxpor/sdl2-manpage.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+sdl1"

DEPEND="!sdl1? ( !media-libs/libsdl )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	FILES=($(find ./src -type f -name '*.3' -exec basename {} \;))
	TARGET="${D}/usr/share/man/man3"
	mkdir -p "${TARGET}"

	if use sdl1; then
		for f in "${FILES[@]}"; do
			mv "./src/${f}" "./src/${f/SDL/SDL2}"
			install -m 644 "./src/${f/SDL/SDL2}" "${TARGET}/"
		done
	else
		for f in "${FILES[@]}"; do
			install -m 644 "./src/${f}" "${TARGET}/"
		done
	fi
	einstalldocs
}
