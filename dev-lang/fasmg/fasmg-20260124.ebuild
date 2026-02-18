# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="l2fx"
MY_COMMIT="584eb31602a8070b95d83974cae68c30d416c19f"
MY_P="${PN}-${MY_COMMIT}"

DESCRIPTION="flat assembler"
HOMEPAGE="https://flatassembler.net/"
SRC_URI="https://github.com/tgrysztar/${PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+examples +system-bootstrap"

BDEPEND="
	system-bootstrap? (
		|| (
			dev-lang/fasm
			dev-lang/fasmg
		)
	)
"

QA_PRESTRIPPED="/usr/bin/fasmg"
QA_FLAGS_IGNORED="/usr/bin/fasmg"
DOCS=("core/docs/fasmg.txt" "core/docs/manual.txt")

case "${ARCH}" in
amd64) SOURCES="core/source/linux/x64" ;;
x86) SOURCES="core/source/linux" ;;
esac

case "${ARCH}" in
amd64) EXEC="core/fasmg.x64" ;;
x86) EXEC="core/fasmg" ;;
esac

src_prepare() {
	# Add fasm-struct.inc to build using fasm
	mkdir -pv "${WORKDIR}/include/macro" || die
	cp -v "${FILESDIR}/fasm-struct.inc" "${WORKDIR}/include/macro/struct.inc" || die

	use system-bootstrap || chmod 755 "${EXEC}" || die
	default
}

src_compile() {
	if ! use system-bootstrap || (has_version 'dev-lang/fasmg' && [ "${FASMG_FORCE_FASM-}" != yes ]); then
		use system-bootstrap && fasmg=fasmg || fasmg="${EXEC}"
		einfo "Building using: ${fasmg}"
		"${fasmg}" "${SOURCES}/fasmg.asm" "${SOURCES}/fasmg" \
			|| die "fasmg failed"
	elif has_version 'dev-lang/fasm'; then
		export INCLUDE="${WORKDIR}/include"
		einfo "Building using: fasm"
		fasm -m 65536 "${SOURCES}/fasmg.asm" "${SOURCES}/fasmg" \
			|| die "fasm failed"
	fi
}

src_install() {
	dobin "${SOURCES}/fasmg"

	# Install fasm data and docs
	insinto "/usr/share/${PN}"
	use examples && doins -r "core/examples"
	einstalldocs
}
