# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BINARY_SERVER_PN="scrcpy-server"
BINARY_SERVER_P="${BINARY_SERVER_PN}-v${PV}"

inherit meson ninja-utils

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
SRC_URI="
	https://github.com/Genymobile/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	bin-server? ( https://github.com/Genymobile/${PN}/releases/download/v${PV}/${BINARY_SERVER_P} )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bin-server +lto multilib"

REQUIRED_USE="amd64? ( !bin-server? ( multilib ) )"
DEPEND="
	media-video/ffmpeg:=
	media-libs/libsdl2[video,threads]
"
RDEPEND="${DEPEND}
	dev-util/android-tools
"
BDEPEND="
	virtual/pkgconfig
	!bin-server? (
		virtual/jdk
		multilib? ( dev-util/android-sdk-update-manager )
	)
"

DOCS=("README.md" "FAQ.md")

find_sdk_tools() {
	: "${ANDROID_HOME:=${BROOT}/opt/android-sdk-update-manager}"
	einfo "Using Android HOME: ${ANDROID_HOME}"

	# Search for build tools and platforms in
	# $ANDROID_HOME/build-tools/$VERSION and in
	# $ANDROID_HOME/platforms/android-$VERSION

	if [ -z "${ANDROID_PLATFORM}" ]; then
		for k in "${ANDROID_HOME}"/platforms/*; do
			[ -f "${k}"/android.jar ] \
				&& ANDROID_PLATFORM="${k##*android-}"
		done
	fi
	[ -z "${ANDROID_PLATFORM}" ] && die "ANDROID_PLATFORM not found"
	export ANDROID_PLATFORM
	einfo "Found Android platform ${ANDROID_PLATFORM}"

	if [ -z "${ANDROID_BUILD_TOOLS}" ]; then
		for k in "${ANDROID_HOME}"/build-tools/"${ANDROID_PLATFORM}"*; do
			[ -x "${k}"/aidl ] \
				&& [ -x "${k}"/dx ] \
				&& ANDROID_BUILD_TOOLS="$(basename -- "${k}")"
		done
	fi
	[ -z "${ANDROID_BUILD_TOOLS}" ] && die "ANDROID_BUILD_TOOLS not found"
	export ANDROID_BUILD_TOOLS
	einfo "Found Android build tools android-${ANDROID_BUILD_TOOLS}"
}

pkg_pretend() {
	use bin-server || find_sdk_tools
}

src_configure() {
	use bin-server || find_sdk_tools

	local emesonargs=(
		$(meson_use lto b_lto)
		-Dprebuilt_server="$(
			usex bin-server "${DISTDIR}/${BINARY_SERVER_P}" "${S}/server/build/${BINARY_SERVER_PN}"
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
