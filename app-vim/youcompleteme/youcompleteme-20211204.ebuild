# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
VIM_PLUGIN_VIM_VERSION="8.1.2269"

inherit python-single-r1 python-utils-r1 vim-plugin

BASE_REPO_URI="https://github.com/ycm-core/YouCompleteMe"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="${BASE_REPO_URI}.git"
	EGIT_SUBMODULES=()
else
	COMMIT_HASH="ab28bd7ac96eb0e16aca0e55208b096f2c06360d"
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

src_prepare() {
	default

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
	python_optimize python
	vim-plugin_src_install
}
