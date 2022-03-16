# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..10} )

inherit python-r1 meson xdg-utils

DESCRIPTION="Bubblewrap based sandboxing for desktop applications"
HOMEPAGE="https://github.com/igo95862/bubblejail"
SRC_URI="https://github.com/igo95862/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X +bash-completion fish-completion"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	sys-libs/libseccomp
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/tomli-w[${PYTHON_USEDEP}]
	X? ( dev-python/PyQt5[${PYTHON_USEDEP},widgets] )
"
RDEPEND="${DEPEND} ${PYTHON_DEPS}
	sys-apps/bubblewrap
	sys-apps/xdg-dbus-proxy
	dev-util/desktop-file-utils
"
BDEPEND="
	sys-devel/m4
"

DOCS=( README.md docs/breaking_changes.md )

src_configure() {
	local emesonargs=(
		-Duse_python_site_packages_dir=true
	)
	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	python_foreach_impl meson_src_test
}

src_install() {
	src_install_python() {
		python_fix_shebang "${BUILD_DIR}"/m4/*
		meson_src_install
		python_optimize
	}
	python_foreach_impl src_install_python
	if ! use fish-completion; then
		rm -rv "${ED}"/usr/share/fish/vendor_completions.d || die
	fi
	if ! use bash-completion; then
		rm -rv "${ED}"/usr/share/bash-completion || die
	fi
	if ! use X; then
		rm -rv \
			"${ED}"/usr/share/applications \
			"${ED}"/usr/share/icons \
			|| die
		rm -v "${ED}"/usr/bin/bubblejail-config || die
	fi
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
