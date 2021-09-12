# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="py-SMART"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{8..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Wrapper for smartctl (smartmontools)"
HOMEPAGE="https://github.com/truenas/py-SMART"
SRC_URI="https://github.com/truenas/py-SMART/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/humanfriendly"
RDEPEND="${DEPEND}
	sys-apps/smartmontools
"
BDEPEND=""

DOCS=( CHANGELOG.md README.md )

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
