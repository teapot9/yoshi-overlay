# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="RPi.GPIO"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_8 )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="A Python module to control the GPIO on a Raspberry Pi"
HOMEPAGE="https://sourceforge.net/projects/raspberry-gpio-python/"
SRC_URI="https://sourceforge.net/projects/raspberry-gpio-python/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""
# fail because don't detect rpi properly
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

distutils_enable_tests unittest
