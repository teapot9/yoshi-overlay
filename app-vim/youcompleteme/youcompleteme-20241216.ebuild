# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
VIM_PLUGIN_VIM_VERSION="9.1.0016"
MY_PN="YouCompleteMe"
COMMIT_HASH="131b1827354871a4e984c1660b6af0fefca755c3"

inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="https://ycm-core.github.io/YouCompleteMe/"
SRC_URI="https://github.com/ycm-core/${MY_PN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${COMMIT_HASH}"

LICENSE="GPL-3"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

VIM_PLUGIN_HELPFILES="${PN}"
VIM_PLUGIN_MESSAGES="filetype"

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
		')
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-20211204-system-ycmd.patch"
)

ignore_test() {
	local file="$1"
	local test regex
	shift
	einfo "Skip tests from ${file}: $*"
	for test in "$@"; do
		regex='^\([[:space:]]*def[[:space:]]\)'"${test}"'\((.*\)$'
		grep -q "${regex}" "${file}" \
			|| die "Test not found: ${test}"
		sed -i "s/${regex}/\\1_${test}\\2/" "${file}" \
			|| die "Failed to remove test: ${test}"
	done
}

src_prepare() {
	default

	sed -e "s:@@PYTHON@@:${EPYTHON}:g" \
		<"${FILESDIR}/${PN}-20230103-python-interpreter.patch" \
		>"${T}/python-interpreter.patch" || die
	eapply "${T}/python-interpreter.patch"

	# System ycmd
	ignore_test python/ycm/tests/youcompleteme_test.py \
		test_YouCompleteMe_NoPythonInterpreterFound \
		test_YouCompleteMe_InvalidPythonInterpreterPath
}

src_test() {
	cd python
	eunittest -b -p '*_test.py' -s ycm.tests
}

src_install() {
	rm -rv test python/ycm/tests third_party || die
	vim-plugin_src_install
	python_domodule python/ycm
}
