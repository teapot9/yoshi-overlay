# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Generate pip requirements.txt file based on imports of any project"
HOMEPAGE="https://github.com/bndr/pipreqs"
SRC_URI="https://github.com/bndr/pipreqs/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="jupyter"
# Tests fail with network-sandbox, since they try to access pypi
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/yarg[${PYTHON_USEDEP}]
	jupyter? (
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? ( ${RDEPEND} )
"

distutils_enable_sphinx docs
distutils_enable_tests unittest

skip_tests() {
	for test in "$@"; do
		einfo "Disabling test ${test}"
		exp='^\([[:space:]]*def[[:space:]]\)\('"${test}"'\)'
		grep -q -e "${exp}" tests/*.py \
			|| die "test ${test} not found"
		sed -i -e 's|'"${exp}"'|\1_\2|' tests/*.py \
			|| die "sed test ${test} failed"
	done
}

src_prepare() {
	# Local tests expect to run in a virtual environment
	skip_tests \
		test_get_use_local_only \
		test_init_local_only
	use jupyter || skip_tests \
		test_import_notebooks \
		test_invalid_notebook \
		test_ipynb_2_py

	distutils-r1_src_prepare
}
