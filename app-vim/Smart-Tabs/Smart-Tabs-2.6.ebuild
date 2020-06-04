# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: Use tabs for indent, spaces for alignment"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=231"
SRC_URI="https://github.com/vim-scripts/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
IUSE=""

VIM_PLUGIN_HELPFILES=""
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""

PATCHES=("${FILESDIR}/${P}-fix-ctab-lastaligh.patch")

