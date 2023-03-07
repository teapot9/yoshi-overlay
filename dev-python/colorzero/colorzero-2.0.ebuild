# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Another color manipulation library for Python (originally from picamera)"
HOMEPAGE="https://colorzero.readthedocs.io/"
SRC_URI="https://github.com/waveform80/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"
S_DOCS="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-2.0-fix-broken-pkginfo.patch"
	"${FILESDIR}/${PN}-2.0-fix-test-coverage.patch"
)

distutils_enable_sphinx docs \
	dev-python/pkginfo \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_prepare() {
	cp "${FILESDIR}/${P}-PKG-INFO" PKG-INFO || die
	distutils-r1_src_prepare
}
