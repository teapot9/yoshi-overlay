# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="sudo shim for doas"
HOMEPAGE="https://github.com/jirutka/doas-sudo-shim"
SRC_URI="https://github.com/jirutka/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-admin/doas
	!app-admin/sudo
"
BDEPEND="dev-ruby/asciidoctor"

src_compile() {
	emake man
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
	einstalldocs
}
