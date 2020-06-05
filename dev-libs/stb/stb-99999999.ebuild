# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="single-file public domain libraries for C/C++"
HOMEPAGE="https://github.com/nothings/stb"
EGIT_REPO_URI="https://github.com/nothings/${PN}.git"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS=""
IUSE=""

PROPERTIES="live"
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=("README.md" "docs")

src_prepare() {
	default

	# Move the header files in a folder so they don't pollute the include dir
	mkdir stb || die "move header failed"
	mv *.h stb/ || die "move header failed"
}

src_install() {
	default
	doheader -r stb
}

