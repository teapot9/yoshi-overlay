# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
inherit distutils-r1

DESCRIPTION="A simple interface to GPIO devices with Raspberry Pi"
HOMEPAGE="https://gpiozero.readthedocs.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~arm64"

RDEPEND="
	dev-python/colorzero[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( ${RDEPEND} )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.1-fix-pin-already-in-use.patch"
)

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's/--cov//' setup.cfg || die
	distutils-r1_src_prepare
}
