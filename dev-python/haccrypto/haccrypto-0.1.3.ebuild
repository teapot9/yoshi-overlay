# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( pypy3 python3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Nintendo Switch XTSN crypto for Python"
HOMEPAGE="https://github.com/luigoalma/haccrypto"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
