# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake systemd

DESCRIPTION="An unofficial userspace driver for HID++ Logitech devices"
HOMEPAGE="https://github.com/PixlOne/logiops"
EGIT_REPO_URI="https://github.com/PixlOne/logiops.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="systemd"

DEPEND="
	dev-libs/libevdev
	virtual/libudev
	dev-libs/libconfig[cxx]
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	# Fix libdir
	sed -i \
		"s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)|g" \
		src/logid/hidpp/src/libhidpp/CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	use systemd && mycmakeargs+=(
		-DSYSTEMD_SERVICES_INSTALL_DIR="$(systemd_get_systemunitdir)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doinitd "${FILESDIR}/logid"
}
