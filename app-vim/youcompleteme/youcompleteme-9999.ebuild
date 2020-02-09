# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
EPYTHON="python3.6"
#VIM_PLUGIN_VIM_VERSION="7.0"
inherit git-r3 vim-plugin python-single-r1 vcs-clean

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="https://github.com/ycm-core/YouCompleteMe"
EGIT_REPO_URI="https://github.com/ycm-core/YouCompleteMe.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+clang +regex csharp go javascript rust java"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
"
DEPEND="${PYTHON_DEPS}
	>=app-editors/vim-7.4.1578[python,${PYTHON_USEDEP}]
	dev-libs/boost[python,threads,${PYTHON_USEDEP}]
	clang? ( >=sys-devel/clang-9.0.0 )
"
RDEPEND="${DEPEND}
	dev-python/bottle[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/sh[${PYTHON_USEDEP}]
	dev-python/waitress[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
"
BDEPEND="dev-util/cmake
"

VIM_PLUGIN_HELPFILES=""
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""

src_compile() {
	args="--system-boost"
	if use clang; then
		args="${args} --system-libclang --clang-completer"
	fi
	if ! use regex; then
		args="${args} --no-regex"
	fi
	eval "${EPYTHON}" ./install.py "${args}" || die "./install.py failed"
}

src_install() {
	dodoc *.md .ycm_extra_conf.py
	einstalldocs
	rm -r *.md *.sh COPYING.txt third_party/ycmd/cpp
	rm -r third_party/ycmd/{*.md,*.sh,examples}
	find python third_party -name "*test*" -exec rm -rf {} +
	find python third_party -name "*doc*" -exec rm -rf {} +
	egit_clean
	rm third_party/ycmd/third_party/clang/lib/libclang.so*

	vim-plugin_src_install

	python_optimize "${ED}"
	python_fix_shebang --force "${ED}"
}

