# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A feature rich cross platform Transmission BitTorrent client"
HOMEPAGE="https://github.com/transmission-remote-gui/transgui"
EGIT_REPO_URI="https://github.com/transmission-remote-gui/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

PROPERTIES="live"
DEPEND="
	>=dev-lang/fpc-2.6.2
	>=dev-lang/lazarus-1.6.0
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	lazbuild -B "./transgui.lpi" || die "lazbuild failed"
}

src_install() {
	emake PREFIX="${ED}/usr" install || die "emake install failed"
	einstalldocs
}
