# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PV="${PV}a0"
MY_P="${PN}-${MY_PV}"

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1 python-r1

DESCRIPTION="TUI and CLI client for the Transmission daemon"
HOMEPAGE="https://github.com/rndusr/stig https://pypi.org/project/stig/"
SRC_URI="https://github.com/rndusr/stig/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="proxy setproctitle"
# No tests due to dev-python/asynctest not supporting python >= 3.8
RESTRICT="test"

DEPEND="
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/urwidtrees[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	dev-python/async_timeout[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]
	setproctitle? ( dev-python/setproctitle[${PYTHON_USEDEP}] )
	proxy? ( dev-python/aiohttp-socks[${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}"
BDEPEND=""
