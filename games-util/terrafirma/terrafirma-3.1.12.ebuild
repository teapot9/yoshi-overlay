# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN="TerraFirma"

inherit cmake

DESCRIPTION="Mapping for Terraria"
HOMEPAGE="https://seancode.com/terrafirma/"
SRC_URI="https://github.com/mrkite/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtbase:6=[gui,opengl,widgets]
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}/${P}-fix-install-paths.patch" )
