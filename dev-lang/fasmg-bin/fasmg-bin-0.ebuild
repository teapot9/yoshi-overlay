# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="fasmg"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/"
SRC_URI="https://flatassembler.net/${MY_PN}.zip"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+examples"

RESTRICT="mirror"
PROPERTIES="live"
REQUIRED_USE="^^ ( amd64 x86 )"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=("license.txt" "docs")
DATAS=()
DATA_DIR="/opt/${MY_PN}"

case "${ARCH}" in
amd64) EXEC="${S}/fasmg.x64" ;;
x86) EXEC="${S}/fasmg" ;;
esac

src_install() {
	into "/opt"
	newbin "${EXEC}" "fasmg" || die

	use examples && DATAS+=("examples")
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f -executable -delete
	find "${DATAS[@]}" -type f -name "*.o" -delete
	# Install fasm data and docs
	insinto "${DATA_DIR}"
	doins -r "${DATAS[@]}"
	einstalldocs
}

