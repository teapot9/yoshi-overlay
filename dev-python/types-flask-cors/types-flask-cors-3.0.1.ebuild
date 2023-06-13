# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="types-Flask-Cors"
MY_P="${MY_PN}-${PV}"

PYPI_PN="${MY_PN}"
PYPI_NO_NORMALIZE=yes
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Typing stubs for flask-cors"
HOMEPAGE="https://pypi.org/project/types-Flask-Cors/"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
