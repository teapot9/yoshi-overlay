# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Tiny system info for Unix-like operating systems"
HOMEPAGE="https://gitlab.com/jschx/ufetch"
EGIT_REPO_URI="https://gitlab.com/jschx/${PN}.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

PROPERTIES="live"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	mv ufetch-gentoo ufetch
}

src_install() {
	dobin ufetch
}
