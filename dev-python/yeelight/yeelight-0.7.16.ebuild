# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A Python library for controlling YeeLight RGB bulbs"
HOMEPAGE="https://gitlab.com/stavros/python-yeelight"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-python/ifaddr[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( ${RDEPEND} )
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme

python_test() {
	epytest yeelight/tests.py
}

python_install_all() {
	use examples && DOCS+=( examples )
	distutils-r1_python_install_all
}
