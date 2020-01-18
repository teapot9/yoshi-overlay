# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Transmission Remote GUI, front-end to remotely control Transmissio daemon"
HOMEPAGE="https://github.com/transmission-remote-gui/transgui"
SRC_URI="https://github.com/transmission-remote-gui/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/fpc-2.6.2
	>=dev-lang/lazarus-1.6.0"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	lazbuild -B "./transgui.lpi" --lazarusdir="/usr/share/lazarus/"
}

src_install() {
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake PREFIX="${D}/usr" install
	fi
	einstalldocs
}
