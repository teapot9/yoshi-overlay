# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="jxp0"
MY_COMMIT="a6181813411f2c412e2eba96cd91c2030fe8c3af"
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
BDEPEND=""

QA_PREBUILT="/opt/bin/fasmg"
DOCS=("core/docs/fasmg.txt" "core/docs/manual.txt" "core/readme.txt")

case "${ARCH}" in
amd64) EXEC="core/fasmg.x64" ;;
x86) EXEC="core/fasmg" ;;
esac

src_install() {
	into "/opt"
	newbin "${EXEC}" "fasmg" || die

	# Install fasm data and docs
	insinto "/opt/${MY_PN}"
	use examples && doins -r "core/examples"
	einstalldocs
}
