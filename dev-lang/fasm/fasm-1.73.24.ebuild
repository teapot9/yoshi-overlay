# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/"
SRC_URI="
	https://flatassembler.net/${P}.tgz
	headers? ( https://flatassembler.net/${PN}w${PV//./}.zip )
"
S="${WORKDIR}/${PN}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+examples +headers +tools"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	|| (
		dev-lang/fasm-bin
		dev-lang/fasm
	)
	headers? ( app-arch/unzip )
"

QA_PRESTRIPPED="/usr/bin/fasm"
DOCS=("fasm.txt" "license.txt" "whatsnew.txt")

case "${ARCH}" in
amd64) SOURCES="source/Linux/x64" ;;
x86) SOURCES="source/Linux" ;;
esac

src_prepare() {
	default
	if use headers; then
		mv "${WORKDIR}/INCLUDE" "${S}/"
		# Headers files should be lowercase
		shopt -s globstar
		for file in ./INCLUDE/**; do
			dirname="$(dirname -- "${file}")"
			basename="$(basename -- "${file}")"
			mv -v "${dirname,,}/${basename}" "${dirname,,}/${basename,,}"
		done
		shopt -u globstar
	fi
}

src_compile() {
	fasm "${SOURCES}/fasm.asm" "${SOURCES}/fasm" || die "fasm failed"
}

src_install() {
	dobin "${SOURCES}/fasm" || die

	DATAS=(
		$(usex examples "examples" "")
		$(usex tools "tools" "")
		$(usex headers "include" "")
	)
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f \( -name "*.o" -o -executable \) -delete
	# Install fasm data and docs
	insinto "/usr/share/${PN}"
	[ "${#DATAS[@]}" -ne 0 ] && doins -r "${DATAS[@]}"
	einstalldocs
}
