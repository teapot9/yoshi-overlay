# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: Helpers for UNIX"
HOMEPAGE="https://github.com/tpope/vim-eunuch"
SRC_URI="https://github.com/tpope/vim-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vim-${P}"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"
