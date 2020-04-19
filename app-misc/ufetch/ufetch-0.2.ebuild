# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tiny system info for Unix-like operating systems"
HOMEPAGE="https://gitlab.com/jschx/ufetch"
SRC_URI="https://gitlab.com/jschx/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	mv ufetch-gentoo ufetch
}

src_install() {
	dobin ufetch
}

