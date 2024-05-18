# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A Python library for controlling YeeLight RGB bulbs"
HOMEPAGE="https://gitlab.com/stavros/python-yeelight"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-python/ifaddr[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/async-timeout[${PYTHON_USEDEP}]
	' python3_10 pypy3)
"
BDEPEND="
	test? ( ${RDEPEND} )
"

PATCHES=(
	"${FILESDIR}/${P}-remove-future.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme

python_test() {
	epytest yeelight/tests.py
}

python_install_all() {
	use examples && DOCS+=( examples )
	distutils-r1_python_install_all
}
