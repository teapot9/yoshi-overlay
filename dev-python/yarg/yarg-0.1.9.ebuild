# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..9} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit python-r1 distutils-r1

DESCRIPTION="A semi hard Cornish cheese, also queries PyPI"
HOMEPAGE="https://yarg.readthedocs.io/"
SRC_URI="https://github.com/kura/yarg/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=("${FILESDIR}/${P}-fix-find-packages.patch")

distutils_enable_sphinx docs/source
distutils_enable_tests nose
