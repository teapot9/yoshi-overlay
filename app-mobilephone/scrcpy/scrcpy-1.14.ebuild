# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BINARY_SERVER_PN="scrcpy-server"

inherit meson ninja-utils

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
SRC_URI="
	https://github.com/Genymobile/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	bin-server? ( https://github.com/Genymobile/${PN}/releases/download/v${PV}/${BINARY_SERVER_PN}-v${PV} )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+lto bin-server multilib"

REQUIRED_USE="amd64? ( !bin-server? ( multilib ) )"
DEPEND="
	virtual/ffmpeg
	media-libs/libsdl2
"
RDEPEND="${DEPEND}
	dev-util/android-tools
"
BDEPEND="
	!bin-server? ( virtual/jdk:1.8 )
"

if [ -z "${FORCE_MANUAL_SDK}" ]; then
	BDEPEND="${BDEPEND}
		!bin-server? ( multilib? ( dev-util/android-sdk-update-manager ) )"
fi

DOCS=("README.md" "FAQ.md" "DEVELOP.md")
PATCHES=("${FILESDIR}/${P}-fix-build-without-gradle.patch")

pkg_pretend() {
	[ -n "${FORCE_MANUAL_SDK}" ] \
		&& einfo "FORCE_MANUAL_SDK set: disabling dependency on" \
		&& einfo "dev-util/android-sdk-update-manager" \
		&& ewarn "Make sure ANDROID_HOME is set correctly"
}

find_sdk_tools() {
	# Search for build tools and platforms in
	# $ANDROID_HOME/build-tools/$VERSION and in
	# $ANDROID_HOME/platforms/android-$VERSION

	if [ -z "${ANDROID_BUILD_TOOLS}" ]; then
		for k in "${ANDROID_HOME}"/build-tools/*; do
			[ -e "${k}" ] && ANDROID_BUILD_TOOLS="$(basename -- "${k}")"
		done
	fi

	if [ -z "${ANDROID_PLATFORM}" ]; then
		for k in "${ANDROID_HOME}"/platforms/*; do
			[ -e "${k}" ] && ANDROID_PLATFORM="${k##*android-}"
		done
	fi

	# Check something has been found
	[ -z "${ANDROID_BUILD_TOOLS}" ] && die "ANDROID_BUILD_TOOLS not found"
	[ -z "${ANDROID_PLATFORM}" ] && die "ANDROID_PLATFORM not found"
	export ANDROID_BUILD_TOOLS
	export ANDROID_PLATFORM
}

src_configure() {
	use bin-server || find_sdk_tools

	local emesonargs=(
		$(meson_use lto b_lto)
		-Dprebuilt_server="$(
			usex bin-server "${DISTDIR}/${BINARY_SERVER_PN}-v${PV}" "${S}/server/build/${BINARY_SERVER_PN}"
		)"
	)
	meson_src_configure
}

src_compile_server() {
	BUILD_DIR="./server/build" \
		./server/build_without_gradle.sh \
		|| die "build server failed"
}

src_compile() {
	use bin-server || src_compile_server
	meson_src_compile
}

pkg_postinst() {
	if use bin-server; then
		einfo "${PN} installed with bin-server useflag enabled"
		einfo "Using a prebuilt ${BINARY_SERVER_PN} binary"
	fi
}
