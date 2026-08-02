# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OTPClient"
inherit cmake gnome2-utils xdg-utils

DESCRIPTION="Highly secure and easy to use OTP client written in C/GTK"
HOMEPAGE="https://github.com/paolostivanin/OTPClient"
SRC_URI="https://github.com/paolostivanin/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="X +cli +trayicon +search-provider"
REQUIRED_USE="
	|| ( X cli )
	trayicon? ( X )
"

# libuuid provided by sys-apps/util-linux in @system
DEPEND="
	app-crypt/libsecret
	dev-libs/glib:2=
	dev-libs/jansson:=
	>=dev-libs/libcotp-4:=
	dev-libs/libgcrypt:=
	X? (
		gui-libs/libadwaita:1=
		dev-libs/protobuf-c:=
		media-gfx/qrencode:=
		media-gfx/zbar
		x11-libs/gdk-pixbuf:2=
		gui-libs/gtk:4=
	)
"
RDEPEND="${DEPEND}"
IDEPEND="
	X? ( dev-util/gtk-update-icon-cache )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GUI=$(usex X ON OFF)
		-DBUILD_SEARCH_PROVIDER=$(usex search-provider ON OFF)
		-DBUILD_CLI=$(usex cli ON OFF)
		-DENABLE_MINIMIZE_TO_TRAY=$(usex trayicon ON OFF)
		-DIS_FLATPAK=OFF
	)
	cmake_src_configure
}

src_test() {
	ulimit -l 65536
	cmake_src_test
}

src_install() {
	cmake_src_install

	insinto /etc/security/limits.d
	newins "${FILESDIR}/limits.conf" 21-otpclient.conf

	# Will collide with dev-libs/glib
	rm -v "${ED}"/usr/share/glib-2.0/schemas/gschemas.compiled || die
}

pkg_postinst() {
	elog "If you were using <net-admin/otpclient-4.0 you must do database"
	elog "migration by starting <net-admin/otpclient-5.1."
	elog "If you were using <net-admin/otpclient-3.2 you must do database"
	elog "migration by starting <net-admin/otpclient-4.3."

	if use X; then
		xdg_icon_cache_update
		gnome2_schemas_update
	fi
}

pkg_postrm() {
	if use X; then
		xdg_icon_cache_update
		gnome2_schemas_update
	fi
}
