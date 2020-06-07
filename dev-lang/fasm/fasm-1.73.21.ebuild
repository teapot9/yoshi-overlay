# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/"
SRC_URI="https://flatassembler.net/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bootstrap +examples"

REQUIRED_USE="^^ ( amd64 x86 )"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="|| ( dev-lang/fasm-bin dev-lang/fasm )"

DOCS=("fasm.txt" "license.txt" "whatsnew.txt")
DATAS=("tools")
DATA_DIR="/usr/share/${PN}"

case "${ARCH}" in
amd64) SOURCES="${S}/source/Linux/x64" ;;
x86) SOURCES="${S}/source/Linux" ;;
esac

src_compile() {
	cd "${SOURCES}"
	fasm "fasm.asm" "fasm" || die "fasm failed"
	if use bootstrap; then
		./fasm "fasm.asm" "fasm-final"
		mv "fasm-final" "fasm"
	fi
}

src_install() {
	dobin "${SOURCES}/fasm"

	use examples && DATAS+=("examples")
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f -executable -delete
	find "${DATAS[@]}" -type f -name "*.o" -delete
	# Install fasm data and docs
	insinto "${DATA_DIR}"
	doins -r "${DATAS[@]}"
	einstalldocs
}
