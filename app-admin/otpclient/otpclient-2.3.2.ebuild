# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="OTPClient"

inherit cmake

DESCRIPTION="Highly secure and easy to use OTP client written in C/GTK"
HOMEPAGE="https://github.com/paolostivanin/OTPClient"
SRC_URI="https://github.com/paolostivanin/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X +cli"

DEPEND="
	x11-libs/gtk+:3
	dev-libs/glib
	dev-libs/jansson
	dev-libs/libgcrypt
	dev-libs/libzip
	media-libs/libpng
	dev-libs/libcotp
	media-gfx/zbar
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	for manpage in "otpclient.1" "otpclient-cli.1"; do
		gunzip "${manpage}.gz"
		sed -i -e "s|${manpage}.gz|${manpage}|" CMakeLists.txt
	done
	cmake_src_prepare
}
src_configure() {
	local mycmakeargs=(
		-DBUILD_GUI=$(usex X)
		-DBUILD_CLI=$(usex cli)
	)
	cmake_src_configure
}
