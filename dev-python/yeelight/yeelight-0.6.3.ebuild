# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="A Python library for controlling YeeLight RGB bulbs."
HOMEPAGE="https://gitlab.com/stavros/python-yeelight https://pypi.org/project/yeelight/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/ifaddr[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

python_test() {
	epytest yeelight/tests.py
}
