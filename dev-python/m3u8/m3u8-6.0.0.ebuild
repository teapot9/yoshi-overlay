# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Python m3u8 Parser for HTTP Live Streaming (HLS) Transmissions"
HOMEPAGE="https://github.com/globocom/m3u8"
SRC_URI="https://github.com/globocom/m3u8/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

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
