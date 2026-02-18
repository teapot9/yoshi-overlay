# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
PYTHON_REQ_USE="xml(+)"
COMMIT_HASH="bd0d133d070199717cddfcfa945d3236c4e3a580"

inherit cmake python-r1 flag-o-matic

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

SRC_URI="https://github.com/ycm-core/ycmd/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
NPM_MIRROR="https://registry.npmjs.org"
GENERIC_SERVER_DEPS="
	vscode-languageserver-textdocument-1.0.1
	vscode-jsonrpc-5.0.1
	vscode-languageserver-types-3.15.1
	vscode-languageserver-protocol-3.15.3
	vscode-languageserver-6.1.1
	semver-6.3.0
	vscode-languageclient-6.1.3
	@types/mocha-8.2.3
	@types/node-12.20.24
	@types/vscode-1.43.0
"
SRC_URI+="
	test? (
		$(get_npm_uri ${GENERIC_SERVER_DEPS})
	)
"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="GPL-3"
SLOT="0"
IUSE="clang clangd cs doc examples go java javascript rust test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CLANG_VERSION=21
LLVM_DIR="/usr/lib/llvm/${CLANG_VERSION}"
RUST_VERSION=1.91.0
RUST_DIR="/usr/lib/rust/${RUST_VERSION}"

DEPEND="
	dev-cpp/abseil-cpp:=
	clang? ( llvm-core/clang:${CLANG_VERSION}= )
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/parso[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	clangd? ( llvm-core/clang:${CLANG_VERSION}=[extra] )
	cs? ( ~dev-dotnet/omnisharp-roslyn-bin-1.37.11[http] )
	go? ( =dev-go/gopls-0.20* )
	java? ( =dev-java/eclipse-jdt-ls-bin-1.51* )
	javascript? ( dev-lang/typescript )
	rust? ( || (
		dev-lang/rust:${RUST_VERSION}[rust-analyzer,rust-src]
		dev-lang/rust-bin:${RUST_VERSION}[rust-analyzer,rust-src]
	) )
"
BDEPEND="
	${PYTHON_DEPS}
	test? (
		${RDEPEND}
		dev-cpp/gtest
		dev-lang/typescript
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyhamcrest[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		net-libs/nodejs[npm]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-20210903-fix-core-version.patch"
	"${FILESDIR}/${PN}-20210903-fix-devdep.patch"
	"${FILESDIR}/${PN}-20211204-cmake-use-build.patch"
	"${FILESDIR}/${PN}-20230824-system-jdtls.patch"
	"${FILESDIR}/${PN}-20240217-system-omnisharp.patch"
	"${FILESDIR}/${PN}-20240823-fix-watchdog-v5-compat.patch"
	"${FILESDIR}/${PN}-20240823-fix-tests-timeout.patch"
	"${T}/system-clang.patch"
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

ignore_all_tests() {
	local file test
	einfo "Skip all tests from $*"
	for file in "$@"; do
		[ -f "${file}" ] || die "Test file not found: ${file}"
		while read -r test; do
			ignore_test "${file}" "${test}"
		done < <(grep -o '^[[:space:]]*def[[:space:]]*test_.*$' "${file}" | grep -o 'test_[^(]*')
	done
}

src_prepare() {
	# Don't test the third party generic server
	rm -rv "${S}"/third_party/generic_server/client/src/test || die

	# Use system clang, llvm and pybind11 (use upstream whereami)
	rm -rv third_party/clang cpp/{llvm,pybind11} || die

	# Copy core version info into ycmd
	cp -v CORE_VERSION ycmd/ || die

	# Write clang version
	sed -e "s/@@CLANG_VERSION@@/${CLANG_VERSION}/g" \
		"${FILESDIR}/${PN}-20241214-system-clang.patch" \
		>"${T}/system-clang.patch" || die

	# Set default configuration
	if use clangd; then
		ycmd_defconfig_set use_clangd 1
		ycmd_defconfig_set clangd_binary_path "\"${LLVM_DIR}/bin/clangd\""
	else
		ycmd_defconfig_set use_clangd 0
	fi
	if use go; then
		ycmd_defconfig_set gopls_binary_path '"gopls"'
	fi
	if use rust; then
		ycmd_defconfig_set rust_toolchain_root "\"${RUST_DIR}\""
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

	# Disable failing / USE-specific tests

	# c: system clang
	ignore_test ycmd/tests/utils_test.py \
		test_GetClangResourceDir_NotFound
	# c: system clangd
	ignore_test ycmd/tests/clangd/utilities_test.py \
		test_ClangdCompleter_GetClangdCommand_NoCustomBinary \
		test_ClangdCompleter_ShouldEnableClangdCompleter
	# c: failing tests
	ignore_test ycmd/tests/clang/diagnostics_test.py \
		test_Diagnostics_CUDA_Kernel
	ignore_test ycmd/tests/clangd/diagnostics_test.py \
		test_Diagnostics_CUDA_Kernel
	ignore_test ycmd/tests/clangd/get_completions_test.py \
		test_GetCompletions_cuda \
		test_GetCompletions_WithHeaderInsertionDecorators

	# c#: system omnisharp
	ignore_test ycmd/tests/cs/debug_info_test.py \
		test_GetCompleter_RoslynFromUserOption \
		test_GetCompleter_RoslynNotFound

	# go: system gopls
	ignore_test ycmd/tests/go/go_completer_test.py \
		test_GetCompleter_GoplsNotFound
	# go: bug: https://github.com/golang/go/issues/68904
	ignore_test ycmd/tests/go/subcommands_test.py \
		test_Subcommands_FixIt_NullResponse \
		test_Subcommands_FixIt_Simple

	# java: system jdtls
	ignore_test ycmd/tests/java/debug_info_test.py \
		test_DebugInfo_JvmArgs
	ignore_test ycmd/tests/java/java_completer_test.py \
		test_ShouldEnableJavaCompleter_NoLauncherJar \
		test_ShouldEnableJavaCompleter_NotInstalled
	# java: failing tests
	ignore_test ycmd/tests/java/server_management_test.py \
		test_ServerManagement_ProjectDetection_GradleMultipleGradleFiles

	# python: system jedi
	ignore_test ycmd/tests/python/subcommands_test.py \
		test_Subcommands_GoTo \
		test_Subcommands_GoToType
	# python: unnecessary dependency
	ignore_test ycmd/tests/python/get_completions_test.py \
		test_GetCompletions_NumpyDoc

	# rust: system rust-analyzer
	ignore_test ycmd/tests/rust/rust_completer_test.py \
		test_GetCompleter_RANotFound \
		test_GetCompleter_WarnsAboutOldConfig
	# rust: failing tests
	ignore_test ycmd/tests/rust/get_completions_proc_macro_test.py \
		test_GetCompletions_ProcMacro
	ignore_test ycmd/tests/rust/subcommands_test.py \
		test_Subcommands_GoTo_WorksAfterChangingProject

	# javascript: failing tests
	ignore_test ycmd/tests/javascriptreact/get_completions_test.py \
		test_GetCompletions_JavaScriptReact_DefaultTriggers

	# Other failing tests
	ignore_test ycmd/tests/utils_test.py \
		test_ImportAndCheckCore_Missing \
		test_ImportAndCheckCore_Unexpected
	ignore_test ycmd/tests/shutdown_test.py \
		test_FromWatchdogWithSubservers \
		test_FromHandlerWithSubservers
		# those also fail if USE=-clang

	# Tern not available
	ignore_all_tests ycmd/tests/tern/*_test.py
	# USE flag exclusions
	use clang || ignore_all_tests ycmd/tests/clang/*_test.py
	use clangd || ignore_all_tests ycmd/tests/clangd/*_test.py
	use cs || ignore_all_tests ycmd/tests/cs/*_test.py
	use go || ignore_all_tests ycmd/tests/go/*_test.py
	use java || ignore_all_tests ycmd/tests/java/*_test.py
	use javascript || ignore_all_tests \
		ycmd/tests/javascript/*_test.py \
		ycmd/tests/javascriptreact/*_test.py \
		ycmd/tests/typescript/*_test.py
	use rust || ignore_all_tests ycmd/tests/rust/*_test.py

	cmake_src_prepare
	# CORE_VERSION needed
	copy_to_build_dir \
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
		append-cppflags $("${LLVM_DIR}/bin/llvm-config" --cppflags)
	fi

	local mycmakeargs=(
		$(usex test -DUSE_SYSTEM_GMOCK=yes '')
		-DUSE_SYSTEM_ABSEIL=yes
		$(usex clang -DUSE_SYSTEM_LIBCLANG=yes '')
		-DUSE_CLANG_COMPLETER=$(usex clang)
		-DCMAKE_SKIP_RPATH=ON
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
	src_test_python() {
		generic_server_compile
		LD_LIBRARY_PATH="${BUILD_DIR}" \
			./ycm/tests/ycm_core_tests \
			|| die "ycm_core_tests failed for ${EPYTHON}"
		rm -v compile_commands.json
		eunittest -b -p '*_test.py' -s ycmd.tests
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
