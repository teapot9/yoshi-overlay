# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="TerraFirma"

inherit qmake-utils

DESCRIPTION="Mapping for Terraria"
HOMEPAGE="https://seancode.com/terrafirma/"
SRC_URI="https://github.com/mrkite/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
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
