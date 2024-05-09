# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple Directmedia Layer man-pages"
HOMEPAGE="https://libsdl.org/"
SRC_URI="https://github.com/libsdl-org/SDL-1.2/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/SDL-1.2-release-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default

	for man in docs/man3/SDL*.3; do
		mv -v "${man}" "${man/SDL/SDL1}" || die
	done
}

src_compile() { :; }

src_install() {
	doman docs/man3/*.3
}
