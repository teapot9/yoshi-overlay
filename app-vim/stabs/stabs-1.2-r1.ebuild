# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: use tabs for indentation and spaces for alignment"
HOMEPAGE="https://github.com/Thyrum/vim-stabs"
SRC_URI="https://github.com/Thyrum/vim-${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vim-${P}"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-fix-cursor-jumps.patch"
)

VIM_PLUGIN_HELPFILES="stabs.txt"
