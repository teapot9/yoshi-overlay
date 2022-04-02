# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN="OTPClient"

inherit cmake xdg-utils

DESCRIPTION="Highly secure and easy to use OTP client written in C/GTK"
HOMEPAGE="https://github.com/paolostivanin/OTPClient"
SRC_URI="https://github.com/paolostivanin/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X +cli"
REQUIRED_USE="|| ( X cli )"

DEPEND="
	X? (
		x11-libs/gtk+:3=
		x11-libs/gdk-pixbuf
		media-libs/libpng:=
		media-gfx/zbar
	)
	dev-libs/glib:2=
	dev-libs/jansson:=
	dev-libs/libgcrypt:=
	dev-libs/libzip:=
	dev-libs/libcotp:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	for manpage in man/*.gz ; do
		gunzip "${manpage}"
		sed -i -e "s|${manpage}|${manpage%.gz}|" CMakeLists.txt
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

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}