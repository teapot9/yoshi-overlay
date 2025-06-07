# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# Missing dependencies for python3_14: dev-python/fs
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python library to interact with Nintendo 3DS files"
HOMEPAGE="https://github.com/ihaveamac/pyctr"
SRC_URI="https://github.com/ihaveamac/pyctr/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="image"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/fs[${PYTHON_USEDEP}]
	dev-python/pyfatfs[${PYTHON_USEDEP}]
	image? ( dev-python/pillow[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? ( ${RDEPEND} )
"

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_prepare() {
	find "${S}" -name '*.py' -print0 \
		| xargs -0 -- sed -i -e 's:Cryptodome:Crypto:g' -- \
		|| die

	distutils-r1_src_prepare
}
