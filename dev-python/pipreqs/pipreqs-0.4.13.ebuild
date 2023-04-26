# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Generate pip requirements.txt file based on imports of any project"
HOMEPAGE="https://github.com/bndr/pipreqs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
# Tests fail with network-sandbox, since they try to access pypi
PROPERTIES="test_network"
RESTRICT="test"

DEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/yarg[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

distutils_enable_sphinx docs
distutils_enable_tests unittest

skip_test() {
	einfo "Disabling test ${1}"
	grep -q '[[:space:]]*def[[:space:]]'"${1}" \
		tests/*.py || die "test ${1} not found"
	sed -i -e 's|^\([[:space:]]*def[[:space:]]\)\('"${1}"'\)|\1_\2|' \
		tests/*.py || die "sed test ${1} failed"
}

src_prepare() {
	skip_test test_get_use_local_only
	skip_test test_init_local_only
	distutils-r1_src_prepare
}
