# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="python-${PN}-v${PV}"
DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit python-utils-r1 python-r1 distutils-r1

DESCRIPTION="A Python library for controlling YeeLight RGB bulbs."
HOMEPAGE="https://gitlab.com/stavros/python-yeelight https://pypi.org/project/yeelight/"
SRC_URI="https://gitlab.com/stavros/python-yeelight/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/ifaddr[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( CHANGELOG.md README.md )

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

python_test() {
	epytest yeelight/tests.py
}

python_install_all() {
	use examples && DOCS+=( examples )
	distutils-r1_python_install_all
}
