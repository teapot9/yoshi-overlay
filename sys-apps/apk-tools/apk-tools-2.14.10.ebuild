# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3,4} luajit )
MY_P="${PN}-v${PV}"
ZSHCOMP_COMMIT="e185ac2775485c65e5ea165a3653c65cdc4303b7"
ZSHCOMP_FILE="${PN}-completion-${ZSHCOMP_COMMIT}.zsh"

inherit flag-o-matic toolchain-funcs lua-single shell-completion

DESCRIPTION="Alpine Package Keeper - package manager for alpine"
HOMEPAGE="https://gitlab.alpinelinux.org/alpine/apk-tools"
SRC_URI="
	https://gitlab.alpinelinux.org/alpine/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2
	zsh-completion? (
		https://gitlab.alpinelinux.org/alpine/aports/-/raw/${ZSHCOMP_COMMIT}/main/${PN}/_apk -> ${ZSHCOMP_FILE}
	)
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="lua static static-libs test zsh-completion"
RESTRICT="!test? ( test )"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

DEPEND="
	lua? ( ${LUA_DEPS} )
	static? (
		dev-libs/openssl:=[static-libs(+)]
		sys-libs/zlib:=[static-libs(+)]
	)
	!static? (
		dev-libs/openssl:=
		sys-libs/zlib:=
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
	lua? (
		$(lua_gen_cond_dep 'dev-lua/lua-zlib[${LUA_USEDEP}]')
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-2.14.10-change-default-root.patch"
)

: ${APK_DEFAULT_ROOT:=${EPREFIX}/var/chroot/alpine}

pkg_pretend() {
	# Tests fail if the directory doesn't exists
	if use test && [ ! -d "${APK_DEFAULT_ROOT}"/var/cache/apk ]; then
		ewarn "Creating directory ${APK_DEFAULT_ROOT}/var/cache/apk."
		mkdir -p "${APK_DEFAULT_ROOT}"/var/cache/apk || die
	fi
}

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	sed -i -e 's|#!/bin/sh|#!/bin/bash|' test/*.sh || die
	default
}

src_configure() {
	append-cppflags -DAPK_DEFAULT_ROOT="\\\"${APK_DEFAULT_ROOT}\\\""
	export PKG_CONFIG="$(tc-getPKG_CONFIG) $(usex static '--static' '')"
	export STATIC=$(usex static y n)
	export LUA="$(usex lua "${ELUA}" no)"
	if use lua; then
		export LUA_VERSION="$(lua_get_version)"
		export LUA_PC="${ELUA}"
		export LUA_LIBDIR="$(lua_get_cmod_dir)"
	fi
}

src_compile() {
	emake compile
	emake docs
}

src_test() {
	emake tmproot="${T}/apk-test" check
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		SBINDIR="/usr/sbin" \
		LIBDIR="/usr/$(get_libdir)" \
		DOCDIR="/usr/share/doc/${PF}" \
		PKGCONFIGDIR="/usr/$(get_libdir)/pkgconfig" \
		install

	use static-libs || rm "${ED}"/usr/"$(get_libdir)"/lib*.a || die
	use static && newsbin src/apk.static apk
	use zsh-completion && newzshcomp "${DISTDIR}/${ZSHCOMP_FILE}" _apk
	einstalldocs
}

pkg_postinst() {
	if ! use lua; then
		elog "USE=-lua has disabled built-in help. Note that manpages"
		elog "are still installed."
	fi
	elog "Default root directory has been set to ${APK_DEFAULT_ROOT}."
	elog "To define a custom root directory, use the apk -p|--root option"
	elog "or define APK_DEFAULT_ROOT in the ebuild environment."
}
