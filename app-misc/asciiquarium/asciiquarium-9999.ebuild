# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Enjoy the mysteries of the sea from the safety of your own terminal!"
HOMEPAGE="https://robobunny.com/projects/asciiquarium/html/"
EGIT_REPO_URI="https://github.com/cmatsuoka/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
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

