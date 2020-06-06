# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="glut"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Original GLUT library manpages"
HOMEPAGE="https://www.opengl.org/resources/libraries/glut/"
SRC_URI="https://www.opengl.org/resources/libraries/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GLUT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+glut +gle"

REQUIRED_USE="|| ( glut gle )"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

MANPAGES_GLUT="./man/glut"
MANPAGES_GLE="./man/gle"

src_compile() {
	:
}

src_install() {
	for dir in $(usex glut "${MANPAGES_GLUT}" '') $(usex gle "${MANPAGES_GLE}" ''); do
		for manpage in "${dir}"/*.man; do
			mv "${manpage}" "${manpage/%.man/.3}"
		done
		doman "${dir}"/*.3
	done
}

