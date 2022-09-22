# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="types-Flask-Cors"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Typing stubs for flask-cors"
HOMEPAGE="https://pypi.org/project/types-Flask-Cors/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
