# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit estack

MY_COMMIT="9a56621e1b04727457ede3dc0f100c70d37ceac0"
MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${MY_COMMIT}"

DESCRIPTION="flat assembler"
HOMEPAGE="https://flatassembler.net/ https://github.com/tgrysztar/fasm"
SRC_URI="https://github.com/tgrysztar/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+tools"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	|| (
		dev-lang/fasm-bin
		dev-lang/fasm
	)
"

QA_PRESTRIPPED="/usr/bin/fasm"
DOCS=("fasm.txt" "whatsnew.txt")

case "${ARCH}" in
amd64) SOURCES="source/linux/x64" ;;
x86) SOURCES="source/linux" ;;
esac

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

src_compile() {
	fasm "${SOURCES}/fasm.asm" "${SOURCES}/fasm" || die "fasm failed"
}

src_install() {
	dobin "${SOURCES}/fasm" || die

	# Install fasm data and docs
	insinto "/usr/share/${PN}"
	use tools && doins -r tools
	einstalldocs
}
