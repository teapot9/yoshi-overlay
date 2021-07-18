# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="pySMART"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{8..9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="Wrapper for smartctl (smartmontools)"
HOMEPAGE="https://github.com/truenas/py-SMART"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/smartmontools
"
BDEPEND=""

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
