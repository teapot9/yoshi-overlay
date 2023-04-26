# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-v${PV}"

inherit meson

DESCRIPTION="pscircle visualizes Linux processes in a form of radial tree"
HOMEPAGE="https://gitlab.com/mildlyparallel/pscircle"
SRC_URI="https://gitlab.com/mildlyparallel/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/cairo[X]"
RDEPEND="${DEPEND}
	media-libs/libpng
	x11-libs/libX11
"
BDEPEND=""

DOCS=("README.md" "CHANGELOG.md")

PATCHES=(
	"${FILESDIR}/${PN}-1.4.0-enable-tests.patch"
)
