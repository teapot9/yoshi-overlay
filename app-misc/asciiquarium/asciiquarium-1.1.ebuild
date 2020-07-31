# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Enjoy the mysteries of the sea from the safety of your own terminal!"
HOMEPAGE="https://robobunny.com/projects/asciiquarium/html/"
SRC_URI="https://robobunny.com/projects/${PN}/${P//-/_}.tar.gz"
S="${WORKDIR}/${P//-/_}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-perl/term-animation
"
BDEPEND=""

src_install() {
	dobin asciiquarium
	einstalldocs
}
