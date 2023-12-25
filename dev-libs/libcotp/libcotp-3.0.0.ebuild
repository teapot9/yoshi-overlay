# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C library that generates TOTP and HOTP"
HOMEPAGE="https://github.com/paolostivanin/libcotp"
SRC_URI="https://github.com/paolostivanin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/3"
KEYWORDS="~amd64"
IUSE="test openssl"
RESTRICT="!test? ( test )"

DEPEND="
	openssl? ( dev-libs/openssl:= )
	!openssl? ( dev-libs/libgcrypt:= )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-libs/criterion )"

DOCS=( README.md SECURITY.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DHMAC_WRAPPER=$(usex openssl openssl gcrypt)
	)
	cmake_src_configure
}

src_test() {
	cmake_src_test
	for exe in "${BUILD_DIR}"/tests/test_*; do
		einfo "Running tests: ${exe}"
		"${exe}" --verbose || die "$(basename -- "${exe}") failed"
	done
}
