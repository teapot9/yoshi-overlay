# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PV="iym4"

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/"
SRC_URI="https://flatassembler.net/${PN}.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bootstrap +examples"

REQUIRED_USE="^^ ( amd64 x86 )"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	|| ( dev-lang/fasmg-bin dev-lang/fasmg )
	app-arch/unzip
"

QA_PRESTRIPPED="/usr/bin/fasmg"
DOCS=("license.txt" "docs")
DATAS=()
DATA_DIR="/usr/share/${PN}"

case "${ARCH}" in
amd64) SOURCES="${S}/source/linux/x64" ;;
x86) SOURCES="${S}/source/linux" ;;
esac

src_compile() {
	cd "${SOURCES}"
	fasmg "fasmg.asm" "fasmg" || die "fasmg failed"
	if use bootstrap; then
		chmod +x fasmg
		./fasmg "fasmg.asm" "fasmg-final" || die "fasmg failed"
		mv "fasmg-final" "fasmg" || die
	fi
}

src_install() {
	dobin "${SOURCES}/fasmg" || die

	use examples && DATAS+=("examples")
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f -executable -delete
	find "${DATAS[@]}" -type f -name "*.o" -delete
	# Install fasm data and docs
	insinto "${DATA_DIR}"
	doins -r "${DATAS[@]}"
	einstalldocs
}
