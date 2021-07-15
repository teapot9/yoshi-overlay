# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..10} )
PYTHON_REQ_USE="xml(+)"

inherit cmake python-r1 python-utils-r1 git-r3 flag-o-matic

get_npm_uri() {
	for pkg in "$@"; do
		[[ "${pkg}" == */* ]] && categ="${pkg%/*}/" || categ=
		tmp="${pkg##*/}"
		name="${tmp%-*}"
		vers="${tmp##*-}"
		echo "${NPM_MIRROR}/${categ}${name}/-/${name}-${vers}.tgz"
	done
}

get_npm_file() {
	for pkg in "$@"; do
		echo "${DISTDIR}/${pkg##*/}.tgz"
	done
}

DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE="https://ycm-core.github.io/ycmd/"
EGIT_REPO_URI="https://github.com/ycm-core/ycmd.git"
EGIT_SUBMODULES=()

NPM_MIRROR="https://registry.npmjs.org"
GENERIC_SERVER_DEPS="
	vscode-languageserver-textdocument-1.0.1
	vscode-jsonrpc-5.0.1
	vscode-languageserver-types-3.15.1
	vscode-languageserver-protocol-3.15.3
	vscode-languageserver-6.1.1
	semver-6.3.0
	vscode-languageclient-6.1.3
	@types/mocha-8.0.3
	@types/node-12.12.0
	@types/vscode-1.57.0
"
SRC_URI="
	test? (
		$(get_npm_uri ${GENERIC_SERVER_DEPS})
	)
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="clang clangd cs doc examples go java javascript rust test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	dev-cpp/abseil-cpp
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	dev-python/parso[${PYTHON_USEDEP}]
	dev-python/bottle[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	clang? ( sys-devel/clang )
	clangd? ( sys-devel/clang )
	cs? ( ~dev-dotnet/omnisharp-roslyn-bin-1.35.4[http] )
	go? ( ~dev-go/gopls-0.6.4 )
	java? ( ~dev-java/eclipse-jdt-ls-bin-0.68.0 )
	javascript? ( dev-lang/typescript )
	rust? ( <=dev-util/rust-analyzer-20210414 )
"
BDEPEND="
	${PYTHON_DEPS}
	test? (
		${RDEPEND}
		dev-cpp/gtest
		net-libs/nodejs[npm]
		dev-python/pyhamcrest[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-fix-devdep.patch"
	"${FILESDIR}/${P}-system-jdtls.patch"
	"${FILESDIR}/${P}-system-omnisharp.patch"
	"${FILESDIR}/${P}-system-clang.patch"
	"${FILESDIR}/${P}-cmake-use-build.patch"
	"${FILESDIR}/${P}-fix-core-version.patch"
)

CMAKE_USE_DIR="${S}/cpp"

ycmd_defconfig_set() {
	YCMD_DEFCONFIG=ycmd/default_settings.json
	local variable="$1"
	local value="$2"

	einfo "Setting default config ${variable} to ${value}"
	grep -q "\"${variable}\"" "${YCMD_DEFCONFIG}" || die
	sed -i 's|\("'"${variable}"'"[[:space:]]*:[[:space:]]*\)[^,}]*|\1'"${value}"'|' \
		"${YCMD_DEFCONFIG}" || die
}

copy_to_build_dir() {
	for file in "$@"; do
		local src="$(pwd)/${file}"
		local dst="${BUILD_DIR}/${file}"
		local dir="$(dirname -- "${dst}")"

		einfo "Copying ${src} -> ${dst}"
		mkdir -p "${dir}" || die "create directory ${dir} failed"
		cp -r "${src}" "${dst}" || die "copy ${src} to ${dst} failed"
		chmod -R u+rw "${dst}" || ewarn "chmod ${dst} failed"
	done
}

src_prepare() {
	# Don't test the third party generic server
	rm -rv "${S}"/third_party/generic_server/client/src/test || die

	# Use system clang, llvm and pybind11 (use upstream whereami)
	rm -rv third_party/clang cpp/{llvm,pybind11} || die

	# Copy core version info into ycmd
	cp -v CORE_VERSION ycmd/ || die

	# Set default configuration
	if use clangd; then
		ycmd_defconfig_set use_clangd 1
		ycmd_defconfig_set clangd_binary_path '"clangd"'
	else
		ycmd_defconfig_set use_clangd 0
	fi
	if use go; then
		ycmd_defconfig_set gopls_binary_path '"gopls"'
	fi
	if use rust; then
		ycmd_defconfig_set rust_toolchain_root '"/usr"'
	fi
	if use cs; then
		local omnisharp
		omnisharp="$(type -P omnisharp.http)" \
			|| die "omnisharp not found"
		ycmd_defconfig_set roslyn_binary_path "\"${omnisharp}\""
		ycmd_defconfig_set mono_binary_path '"env"'
	fi
	if use java; then
		ycmd_defconfig_set java_binary_path '"java"'
	fi
	if use javascript; then
		ycmd_defconfig_set tsserver_binary_path '"tsserver"'
	fi

	cmake_src_prepare
	# CORE_VERSION needed
	copy_to_build_dir \
		pytest.ini \
		ycmd \
		.clang-tidy \
		third_party/generic_server
	python_copy_sources
}

src_configure() {
	if use test; then
		export YCM_TESTRUN=1

		# Configure NPM
		export NODE_ENV=production
		einfo "NODE_ENV=${NODE_ENV@Q}"
		NPM_FLAGS+=" --verbose --progress=false --foreground-scripts"
		NPM_FLAGS+=" --audit=false --offline --production"
		einfo "NPM_FLAGS=${NPM_FLAGS@Q}"
	fi

	if use clang; then
		append-cppflags $(llvm-config --cppflags)
	fi

	local mycmakeargs=(
		$(usex test -DUSE_SYSTEM_GMOCK=yes '')
		-DUSE_SYSTEM_ABSEIL=yes
		$(usex clang -DUSE_SYSTEM_LIBCLANG=yes '')
		-DUSE_CLANG_COMPLETER=$(usex clang)
	)

	src_configure_python() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
		cmake_src_configure
	}
	python_foreach_impl run_in_build_dir src_configure_python
}

src_compile() {
	python_foreach_impl run_in_build_dir cmake_src_compile
	python_foreach_impl run_in_build_dir \
		eval mv -v 'ycm/ycm_core.*.so' . || die
	#clang_soname="$(IFS=,; for k in $(scanelf -qF'%n#F' ycm_core.*.so); \
	#                do echo "$k"; done | grep libclang.so | head -1)"
}

generic_server_compile() {
	mkdir -p third_party/generic_server || die
	pushd third_party/generic_server || die

	# Install dependencies
	for dep in ${GENERIC_SERVER_DEPS}; do
		einfo "Installing ${dep} dependency for generic_server"
		file="$(get_npm_file "${dep}")"
		npm ${NPM_FLAGS} install "${file}" \
			|| die "NPM failed to install ${dep} dependency"
	done

	# Install
	einfo "Installing generic_server"
	npm ${NPM_FLAGS} install \
		|| die "NPM failed to install generic_server"
	npm ${NPM_FLAGS} run compile \
		|| die "NPM failed to compile generic_server"

	popd || die
}

src_test() {
	local pytest_exclusions=(
		# System omnisharp
		--deselect "ycmd/tests/cs/debug_info_test.py::GetCompleter_RoslynNotFound_test"
		# System clang
		--deselect "ycmd/tests/utils_test.py::GetClangResourceDir_NotFound_test"
		# System clangd
		--deselect "ycmd/tests/clangd/utilities_test.py::ClangdCompleter_GetClangdCommand_NoCustomBinary_test"
		--deselect "ycmd/tests/clangd/utilities_test.py::ClangdCompleter_ShouldEnableClangdCompleter_test"
		# System gopls
		--deselect "ycmd/tests/go/go_completer_test.py::GetCompleter_GoplsNotFound_test"
		# System jdtls
		--deselect "ycmd/tests/java/java_completer_test.py::ShouldEnableJavaCompleter_NotInstalled_test"
		--deselect "ycmd/tests/java/java_completer_test.py::ShouldEnableJavaCompleter_NoLauncherJar_test"
		--deselect "ycmd/tests/java/debug_info_test.py::DebugInfo_JvmArgs_test[]"
		# System rust-analyzer
		--deselect "ycmd/tests/rust/rust_completer_test.py::GetCompleter_WarnsAboutOldConfig_test"
		--deselect "ycmd/tests/rust/rust_completer_test.py::GetCompleter_RANotFound_test"
		# System jedi
		--deselect "ycmd/tests/python/subcommands_test.py::Subcommands_GoTo_test[-test3-GoTo]"
		--deselect "ycmd/tests/python/subcommands_test.py::Subcommands_GoTo_test[-test3-GoToDefinition]"
		--deselect "ycmd/tests/python/subcommands_test.py::Subcommands_GoTo_test[-test3-GoToDeclaration]"
		--deselect "ycmd/tests/python/subcommands_test.py::Subcommands_GoToType_test[-test0]"
		# Failing test
		--deselect "ycmd/tests/shutdown_test.py::Shutdown_test::FromHandlerWithSubservers_test"
		--deselect "ycmd/tests/shutdown_test.py::Shutdown_test::FromWatchdogWithSubservers_test"
		--deselect "ycmd/tests/clang/diagnostics_test.py::Diagnostics_CUDA_Kernel_test[]"
		--deselect "ycmd/tests/clangd/subcommands_test.py::Subcommands_ServerNotInitialized_test[FixIt-]"
		--deselect "ycmd/tests/clangd/subcommands_test.py::Subcommands_ServerNotInitialized_test[Format-]"
		# Unnecessary dependency
		--deselect "ycmd/tests/python/get_completions_test.py::GetCompletions_NumpyDoc_test[]"
		# Tern not available
		--ignore=ycmd/tests/tern
		# USE flag exclusions
		$(usex clang '' '--ignore=ycmd/tests/clang') \
		$(usex clangd '' '--ignore=ycmd/tests/clangd') \
		$(usex cs '' '--ignore=ycmd/tests/cs') \
		$(usex go '' '--ignore=ycmd/tests/go') \
		$(usex java '' '--ignore=ycmd/tests/java') \
		$(usex javascript '' '--ignore=ycmd/tests/javascript') \
		$(usex javascript '' '--ignore=ycmd/tests/javascriptreact') \
		$(usex javascript '' '--ignore=ycmd/tests/typescript') \
		$(usex javascript '' '--ignore=ycmd/tests/typescriptreact') \
		$(usex rust '' '--ignore=ycmd/tests/rust') \
	)

	src_test_python() {
		generic_server_compile
		LD_LIBRARY_PATH="${BUILD_DIR}" \
			./ycm/tests/ycm_core_tests \
			|| die "ycm_core_tests failed for ${EPYTHON}"
		rm -v compile_commands.json
		epytest \
			-p no:flaky \
			"${pytest_exclusions[@]}" \
			ycmd
	}
	python_foreach_impl run_in_build_dir src_test_python
}

src_install() {
	python_foreach_impl run_in_build_dir \
		rm -rv ycmd/tests || die
	python_foreach_impl run_in_build_dir \
		eval python_domodule 'ycm_core.*.so' ycmd \
		|| die "Failed to install ycmd for ${EPYTHON}"
	use doc && HTML_DOCS+=(docs/.)
	use examples && dodoc -r examples
	einstalldocs
}
