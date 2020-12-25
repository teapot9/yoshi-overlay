# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="fasmg"
MY_PV="j5ii"
MY_COMMIT="333aca542c9a90132826969a1df46b4e81870335"
MY_P="${MY_PN}-${MY_COMMIT}"

DESCRIPTION="flat assembler"
HOMEPAGE="http://flatassembler.net/ https://github.com/tgrysztar/fasmg"
SRC_URI="https://github.com/tgrysztar/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+examples"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

QA_PREBUILT="/opt/bin/fasmg"
DOCS=("core/license.txt" "core/docs" "core/readme.txt")

case "${ARCH}" in
amd64) EXEC="core/fasmg.x64" ;;
x86) EXEC="core/fasmg" ;;
esac

src_install() {
	into "/opt"
	newbin "${EXEC}" "fasmg" || die

	DATAS=($(usex examples "core/examples" ""))
	# Remove binary files (they can be built with fasm)
	find "${DATAS[@]}" -type f \( -name "*.o" -o -executable \) -delete
	# Install fasm data and docs
	insinto "/opt/${MY_PN}"
	[ "${#DATAS[@]}" -ne 0 ] && doins -r "${DATAS[@]}"
	einstalldocs
}
