# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Simple framework for creating REST APIs"
HOMEPAGE="
	https://flask-restful.readthedocs.io/en/latest/
	https://github.com/flask-restful/flask-restful/"
SRC_URI="
	https://github.com/flask-restful/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="examples"
RESTRICT="test"

RDEPEND="
	>=dev-python/aniso8601-0.82[${PYTHON_USEDEP}]
	>=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.3.0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"
BDEPEND=""

distutils_enable_sphinx docs

python_install_all() {
	use examples && dodoc -r examples
	local DOCS=( AUTHORS.md CHANGES.md CONTRIBUTING.md README.md )

	distutils-r1_python_install_all
}
