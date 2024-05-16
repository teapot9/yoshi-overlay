# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Nintendo Switch XTSN crypto for Python"
HOMEPAGE="https://github.com/luigoalma/haccrypto"

LICENSE="MIT openssl"
SLOT="0"
KEYWORDS="~amd64"
