# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# pypy3: TypeError: struct.pack() doesn't supports bytearrays
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python based FAT12/FAT16/FAT32 implementation with VFAT support"
HOMEPAGE="https://github.com/nathanhi/pyfatfs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/fs[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest
