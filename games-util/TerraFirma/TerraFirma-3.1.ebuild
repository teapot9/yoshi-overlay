# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Cross-platform mapping for Terraria"
HOMEPAGE="https://github.com/mrkite/TerraFirma"
SRC_URI="https://github.com/mrkite/${PN}/archive/${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore
	dev-qt/qtwebkit
	dev-qt/qtwebengine"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-fix-qmap.patch"
)

src_configure() {
	qmake || die "qmake failed"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}
