# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MY_COMMIT="e86bb794a1c10a2edac130feb0ea590a00d03f1e"
MY_P="vim-${PN}-${MY_COMMIT}"

DESCRIPTION="vim plugin: Helpers for UNIX"
HOMEPAGE="https://github.com/tpope/vim-eunuch"
SRC_URI="https://github.com/tpope/vim-${PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"
