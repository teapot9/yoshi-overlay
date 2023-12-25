# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="k9zn"
MY_COMMIT="42c46f6bbf71eb239bfeffc9734531525a6ab1b8"
MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${MY_COMMIT}"

DESCRIPTION="flat assembler"
HOMEPAGE="https://flatassembler.net/ https://github.com/tgrysztar/fasmg"
SRC_URI="https://github.com/tgrysztar/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+examples"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	|| (
		dev-lang/fasm
		dev-lang/fasmg-bin
		dev-lang/fasm-bin
		dev-lang/fasmg
	)
"

QA_PRESTRIPPED="/usr/bin/fasmg"
DOCS=("core/docs/fasmg.txt" "core/docs/manual.txt" "core/readme.txt")

case "${ARCH}" in
amd64) SOURCES="core/source/linux/x64" ;;
x86) SOURCES="core/source/linux" ;;
esac

src_prepare() {
	mkdir -pv "${WORKDIR}/include/macro"
	cp -v "${FILESDIR}/fasm-struct.inc" "${WORKDIR}/include/macro/struct.inc"
	default
}

src_compile() {
	if has_version '>=dev-lang/fasmg-20230126' || has_version '>=dev-lang/fasmg-bin-20230126'; then
		fasmg "${SOURCES}/fasmg.asm" "${SOURCES}/fasmg" || die "fasmg failed"
	elif has_version 'dev-lang/fasm' || has_version 'dev-lang/fasmg-bin'; then
		export INCLUDE="${WORKDIR}/include"
		fasm -m 65536 "${SOURCES}/fasmg.asm" "${SOURCES}/fasmg" || die "fasm failed"
	fi
}

src_install() {
	dobin "${SOURCES}/fasmg" || die

	# Install fasm data and docs
	insinto "/usr/share/${PN}"
	use examples && doins -r "core/examples"
	einstalldocs
}
