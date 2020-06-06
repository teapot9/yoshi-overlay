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
IUSE="+lto bin-server"

DEPEND="
	virtual/ffmpeg
	media-libs/libsdl2
"
RDEPEND="${DEPEND}
	dev-util/android-tools
"
BDEPEND="
	!bin-server? (
		dev-util/android-studio
		virtual/jdk:1.8
	)
"

DOCS=("README.md" "FAQ.md" "DEVELOP.md")
PATCHES=("${FILESDIR}/${P}-fix-build-without-gradle.patch")

src_configure() {
	local emesonargs=(
		$(meson_use lto b_lto)
		-Dprebuilt_server="$(
			usex bin-server "${DISTDIR}/${BINARY_SERVER_PN}-v${PV}" "${S}/server/build/${BINARY_SERVER_PN}"
		)"
	)
	meson_src_configure
}

src_compile_server() {
	# Search for build tools and platforms in
	# $ANDROID_HOME/build-tools/$VERSION and in
	# $ANDROID_HOME/platforms/android-$VERSION
	# We test for some files (dx, aidl, android.jar)
	# to make sure the directory is not a ghost
	# from an uninstalled version
	if [ -z "${ANDROID_BUILD_TOOLS:+x}" ]; then
		for k in "${ANDROID_HOME}"/build-tools/*; do
			[ -x "${k}/dx" ] \
				&& [ -x "${k}/aidl" ] \
				&& ANDROID_BUILD_TOOLS="$(basename -- "${k}")"
		done
	fi
	if [ -z "${ANDROID_PLATFORM:+x}" ]; then
		for k in "${ANDROID_HOME}"/platforms/*; do
			[ -f "${k}/android.jar" ] \
				&& ANDROID_PLATFORM="${k##*android-}"
		done
	fi

	# Build the server
	ANDROID_PLATFORM="${ANDROID_PLATFORM:?}" \
		ANDROID_BUILD_TOOLS="${ANDROID_BUILD_TOOLS:?}" \
		BUILD_DIR="./server/build" \
		./server/build_without_gradle.sh || die "build server failed"
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

