# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/"
MY_FILENAME="${PN}.zip"
MY_SRC_URI="https://flatassembler.net/${PN}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+bootstrap +examples"

REQUIRED_USE="^^ ( amd64 x86 )"
RESTRICT="network-sandbox"
PROPERTIES="live"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	|| ( dev-lang/fasmg-bin dev-lang/fasmg )
	app-arch/unzip
"

QA_PRESTRIPPED="/usr/bin/fasmg"
DOCS=("license.txt" "docs")
DATAS=()

case "${ARCH}" in
amd64) SOURCES="${S}/source/linux/x64" ;;
x86) SOURCES="${S}/source/linux" ;;
esac

pkg_pretend(){
	ewarn "This package will download its files without checking their integrity."
}

src_unpack() {
	wget "${MY_SRC_URI}" -O "${WORKDIR}/${MY_FILENAME}"
	unpack "${WORKDIR}/${MY_FILENAME}"
}

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
	insinto "/usr/share/${PN}"
	doins -r "${DATAS[@]}"
	einstalldocs
}
