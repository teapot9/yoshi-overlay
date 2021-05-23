# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="vim-smarttabs"
MY_COMMIT="d1e542c82cbeaf405bae37530264b04449699050"

inherit vim-plugin

DESCRIPTION="vim plugin: Use tabs for indent, spaces for alignment"
HOMEPAGE="https://github.com/dpc/vim-smarttabs"
SRC_URI="https://github.com/dpc/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

LICENSE="vim.org"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="doc/smarttabs.txt"
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""
