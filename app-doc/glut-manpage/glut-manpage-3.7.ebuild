# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GLUT library manpages"
HOMEPAGE="http://freeglut.sourceforge.net/"
SRC_URI="https://www.opengl.org/resources/libraries/glut/glut-3.7.tar.gz"
S="${WORKDIR}/glut-${PV}"

LICENSE="GLUT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+glut +gle"

REQUIRED_USE="|| ( glut gle )"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	:
}

src_install() {
	if use glut; then
		cd ./man/glut
		for f in *.man; do
			mv "${f}" "${f/.man/.3xglut}"
		done
		doman *.3xglut
		cd ../..
	fi
	if use gle; then
		cd ./man/gle
		for f in *.man; do
			mv "${f}" "${f/.man/.3xgle}"
		done
		doman *.3xgle
		cd ../..
	fi
}
