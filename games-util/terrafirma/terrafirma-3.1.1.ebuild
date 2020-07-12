# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="TerraFirma"

inherit qmake-utils

DESCRIPTION="Mapping for Terraria"
HOMEPAGE="https://github.com/mrkite/TerraFirma"
SRC_URI="https://github.com/mrkite/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

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

src_configure() {
	eqmake5 || die "eqmake5 failed"
}

src_install() {
	emake INSTALL_ROOT="${ED}" install || die "emake install failed"
	einstalldocs
}
