# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit python-r1 python-utils-r1 distutils-r1

DESCRIPTION="Python m3u8 Parser for HTTP Live Streaming (HLS) Transmissions"
HOMEPAGE="https://github.com/globocom/m3u8"
SRC_URI="https://github.com/globocom/m3u8/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64"

DEPEND="
	dev-python/iso8601[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-python/bottle[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	"${EPYTHON}" tests/m3u8server.py \
		>"${T}/server-${EPYTHON}.log" 2>&1 &
	local server_pid=$!
	epytest tests
	kill "${server_pid}"
}
