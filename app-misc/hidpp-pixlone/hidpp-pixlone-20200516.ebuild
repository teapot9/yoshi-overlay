# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="hidpp"
MY_COMMIT="c64ec3a12b203024e48993c1aadf4618b3dbd37c"

inherit cmake linux-info

DESCRIPTION="Collection of HID++ tools"
HOMEPAGE="https://github.com/PixlOne/hidpp"
SRC_URI="https://github.com/PixlOne/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="udev"

DEPEND="virtual/libudev"
RDEPEND="${DEPEND}
	dev-libs/tinyxml2
"
BDEPEND=""

CONFIG_CHECK="HIDRAW"

src_prepare() {
	# Fix udev config
	sed -i \
		"s|DESTINATION /etc/udev/rules.d|DESTINATION /lib/udev/rules.d|g" \
		CMakeLists.txt
	# Fix libdir
	sed -i \
		"s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)|g" \
		src/libhidpp/CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DINSTALL_UDEV_RULES=$(usex udev)
	)
	cmake_src_configure
}
