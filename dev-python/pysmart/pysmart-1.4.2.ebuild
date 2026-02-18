# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# python3_14: missing dev-python/humanfriendly
PYTHON_COMPAT=( python3_{11..13} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Wrapper for smartctl (smartmontools)"
HOMEPAGE="https://github.com/truenas/py-SMART"
SRC_URI="https://github.com/truenas/py-SMART/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/py-SMART-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-python/humanfriendly[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	sys-apps/smartmontools
"
BDEPEND="
	doc? ( dev-python/pdoc3 )
	test? ( ${RDEPEND} )
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"

distutils_enable_tests pytest

python_compile_all() {
	if use doc; then
		pdoc --html --output-dir docs pySMART || die "pdoc failed"
	fi
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
