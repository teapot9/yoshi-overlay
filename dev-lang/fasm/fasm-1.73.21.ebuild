# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Flat Assembler"
HOMEPAGE="http://flatassembler.net/"
SRC_URI="https://flatassembler.net/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	if use amd64; then
		./fasm.x64 "./source/Linux/x64/fasm.asm" "fasm.out" || die "fasm failed"
	elif use x86; then
		./fasm "./source/Linux/fasm.asm" "fasm.out" || die "fasm failed"
	else
		die "unknown architecture"
	fi
}

src_install() {
	mkdir -p "${D}/usr/bin"
	install -m 755 "fasm.out" "${D}/usr/bin/fasm"
	mkdir -p "${D}/usr/share/fasm"
	cp -r "tools" "${D}/usr/share/fasm/"
	einstalldocs
}

