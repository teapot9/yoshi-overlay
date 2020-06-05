# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="OpenGL and OpenGL ES reference page sources"
HOMEPAGE="https://github.com/KhronosGroup/OpenGL-Refpages"
EGIT_REPO_URI="https://github.com/KhronosGroup/${PN}.git"

LICENSE="Apache-2.0 CC-BY-4.0"
SLOT="0"
KEYWORDS=""
IUSE="+gl +es"

REQUIRED_USE="|| ( gl es )"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/docbook-xsl-ns-stylesheets
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd
	dev-libs/libxslt
"

MANPAGESDIR_ES=es3
MANPAGESDIR_GL=gl4

src_compile() {
	mkdir build
	cd build
	for manpagedir in $(usex gl "${MANPAGESDIR_GL}" '') $(usex es "${MANPAGESDIR_ES}" ''); do
		xsltproc --xinclude --noout --nonet /usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl ../"${manpagedir}"/*.xml || die "xsltproc failed"
	done
}

src_install() {
	doman build/*.3G
	einstalldocs
}

