# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="A simple interface to GPIO devices with Raspberry Pi"
HOMEPAGE="https://gpiozero.readthedocs.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/colorzero
"
BDEPEND="test? ( dev-python/mock )"

distutils_enable_sphinx docs
distutils_enable_tests pytest
