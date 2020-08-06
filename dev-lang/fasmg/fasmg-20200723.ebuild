# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_COMMIT="bd9688d1a710157550c9fadd18c56954849efa38"
MY_P="${PN}-${MY_COMMIT}"

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/ https://github.com/tgrysztar/fasmg"
SRC_URI="https://github.com/tgrysztar/${PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+examples"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	|| (
		dev-lang/fasm[headers]
		dev-lang/fasm-bin[headers]
		dev-lang/fasmg-bin
		dev-lang/fasmg
	)
"

QA_PRESTRIPPED="/usr/bin/fasmg"
DOCS=("core/license.txt" "core/docs" "core/readme.txt")

case "${ARCH}" in
amd64) SOURCES="core/source/linux/x64" ;;
x86) SOURCES="core/source/linux" ;;
esac

src_compile() {
	if has_version dev-lang/fasmg || has_version dev-lang/fasmg-bin; then
		fasmg "${SOURCES}/fasmg.asm" "${SOURCES}/fasmg" || die "fasmg failed"
	elif has_version dev-lang/fasm || has_version dev-lang/fasmg-bin; then
		export INCLUDE="/usr/share/fasm/include"
		fasm "${SOURCES}/fasmg.asm" "${SOURCES}/fasmg" || die "fasm failed"
	fi
}

src_install() {
	dobin "${SOURCES}/fasmg" || die

	DATAS=($(usex examples "core/examples" ""))
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f \( -name "*.o" -o -executable \) -delete
	# Install fasm data and docs
	insinto "/usr/share/${PN}"
	[ "${#DATAS[@]}" -ne 0 ] && doins -r "${DATAS[@]}"
	einstalldocs
}
