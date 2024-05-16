# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )
inherit distutils-r1

DESCRIPTION="Another color manipulation library for Python (originally from picamera)"
HOMEPAGE="https://colorzero.readthedocs.io/"
SRC_URI="https://github.com/waveform80/colorzero/archive/release-${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~arm64"

PATCHES=(
	"${FILESDIR}/${PN}-2.0-fix-broken-pkginfo.patch"
	"${FILESDIR}/${PN}-2.0-fix-test-coverage.patch"
	"${FILESDIR}/${PN}-2.0-fix-docs-css.patch"
)

distutils_enable_sphinx docs \
	dev-python/pkginfo \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_prepare() {
	cp "${FILESDIR}/${P}-PKG-INFO" PKG-INFO || die
	distutils-r1_src_prepare
}
