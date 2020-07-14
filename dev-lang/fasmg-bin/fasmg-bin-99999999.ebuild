# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="fasmg"

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/"
MY_FILENAME="${MY_PN}.zip"
MY_SRC_URI="https://flatassembler.net/${MY_PN}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+examples"

REQUIRED_USE="^^ ( amd64 x86 )"
RESTRICT="network-sandbox"
PROPERTIES="live"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

QA_PREBUILT="/opt/bin/.*"
DOCS=("license.txt" "docs")
DATAS=()

case "${ARCH}" in
amd64) EXEC="${S}/fasmg.x64" ;;
x86) EXEC="${S}/fasmg" ;;
esac

pkg_pretend(){
	ewarn "This package will download its files without checking their integrity."
}

src_unpack() {
	wget "${MY_SRC_URI}" -O "${WORKDIR}/${MY_FILENAME}"
	unpack "${WORKDIR}/${MY_FILENAME}"
}

src_install() {
	into "/opt"
	newbin "${EXEC}" "fasmg" || die

	use examples && DATAS+=("examples")
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f -executable -delete
	find "${DATAS[@]}" -type f -name "*.o" -delete
	# Install fasm data and docs
	insinto "/opt/${MY_PN}"
	doins -r "${DATAS[@]}"
	einstalldocs
}
