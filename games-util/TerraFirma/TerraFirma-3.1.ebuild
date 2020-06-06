# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Mapping for Terraria"
HOMEPAGE="https://github.com/mrkite/TerraFirma"
SRC_URI="https://github.com/mrkite/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtcore
	dev-qt/qtwebkit
	dev-qt/qtwebengine
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=("${FILESDIR}/${P}-fix-qmap.patch")

src_configure() {
	eqmake5 || die "eqmake5 failed"
}

src_install() {
	emake INSTALL_ROOT="${ED}" install || die "emake install failed"
	einstalldocs
}

