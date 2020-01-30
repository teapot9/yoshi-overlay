# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#VIM_PLUGIN_VIM_VERSION="7.0"
inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: Syntax highlighting for OpenGL Shading Language"
HOMEPAGE="https://github.com/tikhomirov/vim-glsl"
EGIT_REPO_URI="https://github.com/tikhomirov/vim-glsl.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

VIM_PLUGIN_HELPFILES=""
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""

src_install() {
	dodir /usr/share/vim/vimfiles
	cp -R "after" "ftdetect" "indent" "syntax" "${D}/usr/share/vim/vimfiles/" || die "Install failed"
	einstalldocs
}

