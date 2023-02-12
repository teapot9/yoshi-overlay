# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="A simple interface to GPIO devices with Raspberry Pi"
HOMEPAGE="https://gpiozero.readthedocs.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND="${DEPEND}
	dev-python/colorzero[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"
RDEPEND=""
BDEPEND=""

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
