# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A feature rich cross platform Transmission BitTorrent client"
HOMEPAGE="https://github.com/transmission-remote-gui/transgui"
SRC_URI="https://github.com/transmission-remote-gui/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-lang/fpc-2.6.2
	>=dev-lang/lazarus-1.6.0
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	lazbuild \
		-B \
		--lazarusdir="/usr/share/lazarus" \
		--primary-config-path="${S}/lazarus" \
		"./transgui.lpi" || die "lazbuild failed"
}

src_install() {
	emake PREFIX="${ED}/usr" install || die "emake install failed"
	einstalldocs
}
