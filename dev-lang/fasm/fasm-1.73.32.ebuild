# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit estack

MY_COMMIT="825d63c3c0982ae0d459faa430c8d21b8e604777"
MY_P="${PN}-${MY_COMMIT}"

DESCRIPTION="flat assembler"
HOMEPAGE="https://flatassembler.net/"
SRC_URI="
	https://github.com/tgrysztar/${PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz
	!system-bootstrap? (
		amd64? ( https://teapot9-misc.s3.nl-ams.scw.cloud/distfiles/${P}-amd64.bin.xz )
		x86? ( https://teapot9-misc.s3.nl-ams.scw.cloud/distfiles/${P}-x86.bin.xz )
	)
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+tools +system-bootstrap"

BDEPEND="
	system-bootstrap? (
		dev-lang/fasm
	)
"

QA_PRESTRIPPED="/usr/bin/fasm"
QA_FLAGS_IGNORED="/usr/bin/fasm"
DOCS=("fasm.txt")

case "${ARCH}" in
amd64) SOURCES="source/linux/x64" ;;
x86) SOURCES="source/linux" ;;
esac

EXEC="${WORKDIR}/${P}-${ARCH}.bin"

src_prepare() {
	# Rename all files from uppercase to lowercase
	eshopts_push -s globstar
	for file in **; do
		dirname="$(dirname -- "${file}")"
		basename="$(basename -- "${file}")"
		mv -v "${dirname,,}/${basename}" "${dirname,,}/${basename,,}" || die
	done
	eshopts_pop

	use system-bootstrap || chmod 755 "${EXEC}" || die
	default
}

src_compile() {
	use system-bootstrap && fasm=fasm || fasm="${EXEC}"
	einfo "Building using: ${fasm}"
	"${fasm}" "${SOURCES}/fasm.asm" "${SOURCES}/fasm" || die "fasm failed"
}

src_install() {
	dobin "${SOURCES}/fasm"

	# Install fasm data and docs
	insinto "/usr/share/${PN}"
	use tools && doins -r tools
	einstalldocs
}
