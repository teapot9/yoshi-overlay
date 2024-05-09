# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Man-pages created by hands following online API document"
HOMEPAGE="https://github.com/haxpor/sdl2-manpage"
SRC_URI="https://github.com/haxpor/sdl2-manpage/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/sdl2-manpage-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	for man in src/SDL*.3; do
		mv -v "${man}" "${man/SDL/SDL2}" || die
	done
}

src_install() {
	doman src/*.3
	einstalldocs
}
