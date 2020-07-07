# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_COMMIT="8bdb7d441a36a5a9f64b853317a66f9d4a82f08f"

DESCRIPTION="Enjoy the mysteries of the sea from the safety of your own terminal!"
HOMEPAGE="https://robobunny.com/projects/asciiquarium/html/"
SRC_URI="https://github.com/cmatsuoka/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-perl/Term-Animation
"
BDEPEND=""

src_install() {
	dobin asciiquarium
	einstalldocs
}
