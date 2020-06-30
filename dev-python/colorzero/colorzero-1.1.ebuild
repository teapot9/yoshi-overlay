# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Another color manipulation library for Python (originally from picamera)"
HOMEPAGE="https://colorzero.readthedocs.io/"
SRC_URI="https://github.com/waveform80/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-python/coverage
		dev-python/mock
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest
