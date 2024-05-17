# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="RPi.GPIO"
MY_P="${MY_PN}-${PV}"

PYPI_PN="${MY_PN}"
PYPI_NO_NORMALIZE=yes
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A Python module to control the GPIO on a Raspberry Pi"
HOMEPAGE="https://sourceforge.net/projects/raspberry-gpio-python/"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"
# fail because doesn't detect rpi properly
RESTRICT="test"

distutils_enable_tests unittest
