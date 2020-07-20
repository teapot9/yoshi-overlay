# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="fasm"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/"
SRC_URI="
	https://flatassembler.net/${MY_P}.tgz
	headers? ( https://flatassembler.net/${MY_PN}w${PV//./}.zip )
"
S="${WORKDIR}/${MY_PN}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+examples +headers +tools"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="headers? ( app-arch/unzip )"

QA_PREBUILT="/opt/bin/fasm"
DOCS=("fasm.txt" "license.txt" "whatsnew.txt")

case "${ARCH}" in
amd64) EXEC="fasm.x64" ;;
x86) EXEC="fasm" ;;
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

src_install() {
	into "/opt"
	newbin "${EXEC}" "fasm" || die

	DATAS=(
		$(usex examples "examples" "")
		$(usex tools "tools" "")
		$(usex headers "include" "")
	)
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f \( -name "*.o" -o -executable \) -delete
	# Install fasm data and docs
	insinto "/opt/${MY_PN}"
	doins -r "${DATAS[@]}"
	einstalldocs
}
