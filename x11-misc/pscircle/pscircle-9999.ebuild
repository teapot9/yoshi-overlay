# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson

DESCRIPTION="pscircle visualizes Linux processes in a form of radial tree"
HOMEPAGE="https://gitlab.com/mildlyparallel/pscircle"
EGIT_REPO_URI="https://gitlab.com/mildlyparallel/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/cairo[X]"
RDEPEND="${DEPEND}
	media-libs/libpng
	x11-libs/libX11
"
BDEPEND=""

DOCS=("README.md" "CHANGELOG.md")
