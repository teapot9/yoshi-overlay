# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="OpenGL and OpenGL ES reference page sources"
HOMEPAGE="https://github.com/KhronosGroup/OpenGL-Refpages"
EGIT_REPO_URI="https://github.com/KhronosGroup/OpenGL-Refpages"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+gl +es"

REQUIRED_USE="|| ( gl es )"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="app-text/docbook-xsl-ns-stylesheets
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	app-text/docbook-xml-dtd
"

MANPAGESDIR_ES=es3
MANPAGESDIR_GL=gl4

src_compile() {
	if use es; then
		xsltproc --noout --nonet /usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl "${MANPAGESDIR_ES}"/*.xml || die "xsltproc failed"
	fi
	if use gl; then
		xsltproc --noout --nonet /usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl "${MANPAGESDIR_GL}"/*.xml || die "xsltproc failed"
	fi
}

src_install() {
	doman *.3G
	einstalldocs
}
