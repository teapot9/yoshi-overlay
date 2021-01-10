# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit estack

MY_COMMIT="4c3bc1aea8290e2b68d1d39aee2f0e95722e8f1b"
MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${MY_COMMIT}"

DESCRIPTION="flat assembler"
HOMEPAGE="https://flatassembler.net/ https://github.com/tgrysztar/fasm"
SRC_URI="
	https://github.com/tgrysztar/${PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz
	amd64? ( https://raw.githubusercontent.com/teapot9/distfiles/master/${P}-amd64.bin.xz )
	x86? ( https://raw.githubusercontent.com/teapot9/distfiles/master/${P}-x86.bin.xz )
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+tools"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

QA_PREBUILT="/opt/bin/fasm"
DOCS=("fasm.txt" "whatsnew.txt")

src_prepare() {
	eshopts_push -s globstar
	for file in **; do
		dirname="$(dirname -- "${file}")"
		basename="$(basename -- "${file}")"
		mv -v "${dirname,,}/${basename}" "${dirname,,}/${basename,,}" || die
	done
	eshopts_pop
	default
}

src_install() {
	into "/opt"
	newbin "${WORKDIR}/${P}-${ARCH}.bin" "fasm" || die

	# Install fasm data and docs
	insinto "/opt/${MY_PN}"
	use tools && doins -r tools
	einstalldocs
}
