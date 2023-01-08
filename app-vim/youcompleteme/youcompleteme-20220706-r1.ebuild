# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
VIM_PLUGIN_VIM_VERSION="8.1.2269"

inherit python-single-r1 python-utils-r1 vim-plugin

BASE_REPO_URI="https://github.com/ycm-core/YouCompleteMe"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="${BASE_REPO_URI}.git"
	EGIT_SUBMODULES=()
else
	COMMIT_HASH="d35df6136146b12f3a78f8b8fbdaf55f4e2ee462"
	MY_PN="YouCompleteMe"
	SRC_URI="${BASE_REPO_URI}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${COMMIT_HASH}"
fi

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="https://ycm-core.github.io/YouCompleteMe/"

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
