# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo git-r3

DESCRIPTION="Git repository summary on your terminal"
HOMEPAGE="https://github.com/o2sh/onefetch"
EGIT_REPO_URI="https://github.com/o2sh/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

PROPERTIES="live"
DEPEND=""
RDEPEND=""

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

