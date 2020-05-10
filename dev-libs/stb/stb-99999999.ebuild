# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="single-file public domain (or MIT licensed) libraries for C/C++"
HOMEPAGE="https://github.com/nothings/stb"
EGIT_REPO_URI="https://github.com/nothings/stb.git"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default

	# Move the header files in a folder so they don't pollute the include dir
	mkdir stb || die 'prepare failed'
	mv *.h stb/ || die 'prepare failed'
}

src_install() {
	default

	doheader -r stb
}

