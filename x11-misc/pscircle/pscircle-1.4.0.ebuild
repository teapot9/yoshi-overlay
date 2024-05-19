# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

inherit meson

DESCRIPTION="pscircle visualizes Linux processes in a form of radial tree"
HOMEPAGE="https://gitlab.com/mildlyparallel/pscircle"
SRC_URI="https://gitlab.com/mildlyparallel/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="
	x11-libs/cairo[X]
"
RDEPEND="${DEPEND}
	media-libs/libpng:=
	X? ( x11-libs/libX11 )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.0-enable-tests.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_use X enable-x11)
	)
	meson_src_configure
}
