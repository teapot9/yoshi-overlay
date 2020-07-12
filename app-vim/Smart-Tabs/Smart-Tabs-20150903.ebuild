# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="vim-smarttabs"
MY_COMMIT="9de63c059219d885dfbc7192b1248e1bac62bdb5"
#VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: Use tabs for indent, spaces for alignment"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=231"
SRC_URI="https://github.com/dpc/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

LICENSE="vim.org"
KEYWORDS="~amd64"
IUSE=""

VIM_PLUGIN_HELPFILES=""
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""
