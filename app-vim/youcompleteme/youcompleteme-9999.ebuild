# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..10} )
VIM_PLUGIN_VIM_VERSION="8.1.2269"

inherit git-r3 python-single-r1 python-utils-r1 vim-plugin

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="https://ycm-core.github.io/YouCompleteMe/"
EGIT_REPO_URI="https://github.com/ycm-core/YouCompleteMe.git"
EGIT_SUBMODULES=()

LICENSE="GPL-3"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

VIM_PLUGIN_HELPFILES="${PN}"
VIM_PLUGIN_MESSAGES="filetype"

DEPEND=""
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'app-text/ycmd[${PYTHON_USEDEP}]')
	|| (
		app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
		app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
		(
			app-editors/neovim
			$(python_gen_cond_dep 'dev-python/pynvim[${PYTHON_USEDEP}]')
		)
	)
"
BDEPEND="
	${PYTHON_DEPS}
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/pyhamcrest[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=("${FILESDIR}/${P}-system-ycmd.patch")

src_test() {
	epytest \
		--deselect "python/ycm/tests/youcompleteme_test.py::YouCompleteMe_InvalidPythonInterpreterPath_test" \
		--deselect "python/ycm/tests/youcompleteme_test.py::YouCompleteMe_NoPythonInterpreterFound_test" \
		python
}

src_install() {
	rm -rv test python/ycm/tests third_party || die
	python_optimize python
	vim-plugin_src_install
}
