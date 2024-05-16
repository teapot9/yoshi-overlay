# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# python3_10 omitted: missing datetime.datetime.fromisoformat()
# pypy3 omitted: fromisoformat() is missing support for "Z" timezone indicator
# See: https://github.com/python/cpython/issues/80010
# python3_13 omitted: missing dev-python/bottle
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Python m3u8 Parser for HTTP Live Streaming (HLS) Transmissions"
HOMEPAGE="https://github.com/globocom/m3u8"
SRC_URI="https://github.com/globocom/m3u8/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/5"
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
