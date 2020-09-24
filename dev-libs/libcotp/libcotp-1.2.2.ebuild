# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C library that generates TOTP and HOTP"
HOMEPAGE="https://github.com/paolostivanin/libcotp"
SRC_URI="https://github.com/paolostivanin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libgcrypt
	dev-libs/libbaseencode
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-libs/criterion )"

PATCHES=( "${FILESDIR}/${P}-fix-tests.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	cmake_src_test
	"${BUILD_DIR}"/tests/test_cotp || die "test_cotp failed"
}
