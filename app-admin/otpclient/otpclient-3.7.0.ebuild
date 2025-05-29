# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OTPClient"
inherit cmake xdg-utils

DESCRIPTION="Highly secure and easy to use OTP client written in C/GTK"
HOMEPAGE="https://github.com/paolostivanin/OTPClient"
SRC_URI="https://github.com/paolostivanin/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="X +cli"
REQUIRED_USE="|| ( X cli )"

# libuuid provided by sys-apps/util-linux in @system
DEPEND="
	app-crypt/libsecret
	dev-libs/glib:2=
	dev-libs/jansson:=
	dev-libs/libcotp:=
	dev-libs/libgcrypt:=
	dev-libs/libzip:=
	X? (
		dev-libs/protobuf-c:=
		dev-libs/protobuf:=
		media-gfx/qrencode:=
		media-gfx/zbar
		media-libs/libpng:=
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3=
	)
"
RDEPEND="${DEPEND}"
IDEPEND="
	X? ( dev-util/gtk-update-icon-cache )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.6.0-fix-no-x-deps.patch"
)

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
	elog "${MY_PN} requires memlock limit to be at least 64MB. You can check"
	elog "its value by running \`ulimit -Hl\`. If the value is below 65536,"
	elog "change the system limits by editing /etc/security/limits.conf."

	if use X; then
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use X; then
		xdg_icon_cache_update
	fi
}
