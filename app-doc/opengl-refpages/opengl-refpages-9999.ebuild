# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="OpenGL and OpenGL ES reference page sources"
HOMEPAGE="https://github.com/KhronosGroup/OpenGL-Refpages"
EGIT_REPO_URI="https://github.com/KhronosGroup/${PN}.git"

LICENSE="Apache-2.0 CC-BY-4.0 Khronos-CLHPP OPL SGI-B-2.0 W3C"
SLOT="0"
IUSE="+gl +es"

REQUIRED_USE="|| ( gl es )"
BDEPEND="
	app-text/docbook-xsl-ns-stylesheets
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd
	dev-libs/libxslt
"

src_compile() {
	mkdir build
	cd build || die
	for manpagedir in $(usex gl gl4 '') $(usex es es3 ''); do
		xsltproc --xinclude --noout --nonet \
			/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl \
			../"${manpagedir}"/*.xml \
			|| die "xsltproc failed for ${manpagedir}"
	done
}

src_install() {
	doman build/*.3G
	einstalldocs
}
