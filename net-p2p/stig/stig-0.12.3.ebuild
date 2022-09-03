# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PV="${PV}a0"
MY_P="${PN}-${MY_PV}"

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 python-r1

ASYNCTEST_PN="asynctest"
ASYNCTEST_PV="0.13.0"
ASYNCTEST_P="${ASYNCTEST_PN}-${ASYNCTEST_PV}"
ASYNCTEST_S="${WORKDIR}/${ASYNCTEST_P}"

DESCRIPTION="TUI and CLI client for the Transmission daemon"
HOMEPAGE="https://github.com/rndusr/stig https://pypi.org/project/stig/"
SRC_URI="
	https://github.com/rndusr/stig/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz
	test? ( mirror://pypi/${ASYNCTEST_PN:0:1}/${ASYNCTEST_PN}/${ASYNCTEST_P}.tar.gz )
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="proxy setproctitle"

DEPEND="
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/urwidtrees[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	dev-python/async-timeout[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]
	setproctitle? ( dev-python/setproctitle[${PYTHON_USEDEP}] )
	proxy? ( dev-python/aiohttp-socks[${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}"
BDEPEND=""

distutils_enable_tests pytest

python_test() {
	PYTHONPATH="${PYTHONPATH}:${ASYNCTEST_S}" distutils-r1_python_test
}
