# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="xml"
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1 virtualx xdg-utils gnome2-utils

DESCRIPTION="An onscreen keyboard useful for tablet PC users and for mobility impaired users."
HOMEPAGE="https://launchpad.net/onboard"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wayland"

RESTRICT="!test? ( test )"

DEPEND="
	app-text/hunspell:=
	dev-libs/glib:2=
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	gnome-base/dconf
	gnome-base/librsvg
	media-libs/libcanberra
	virtual/libudev
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)
	x11-base/xorg-proto
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3=[introspection,X,wayland?]
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libxkbfile
	x11-libs/pango[introspection]
"
RDEPEND="${DEPEND}
	app-accessibility/at-spi2-core[introspection]
	app-text/iso-codes
	gnome-base/gsettings-desktop-schemas
	gnome-extra/mousetweaks
	sys-libs/ncurses
"
BDEPEND="
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-util/intltool
	test? (
		${RDEPEND}
		${CATEGORY}/${PN}
		dev-python/nose[${PYTHON_USEDEP}]
		x11-misc/xautomation
	)
	virtual/pkgconfig
"

DOCS=(
	COPYING COPYING.BSD3 COPYING.GPL3
	AUTHORS CHANGELOG HACKING NEWS README
	onboard-defaults.conf.example
	onboard-default-settings.gschema.override.example
)

PATCHES=(
	"${FILESDIR}/${P}-fix-musl.patch"
	"${FILESDIR}/${P}-fix-tests-hanging.patch"
	"${FILESDIR}/${P}-fix-python-executable.patch"
)

src_prepare() {
	# Skip problematic tests
	sed -i \
		-e 's:test_gnome_high_contrast_themes:_&:' \
		-e 's:test_numlock_state_on_exit:_&:' \
		-e 's:test_apt_cache_unmet_onboard:_&:' \
		Onboard/test/test_gui.py || die

	distutils-r1_src_prepare
}

python_test() {
	# Hack to avoid import from ${S}
	mv Onboard/__init__.py Onboard/__init__.py.bak || die
	mv Onboard/test test || die

	dbus_eval="$(dbus-launch --sh-syntax)" || die
	eval "${dbus_eval}"
	virtx esetup.py test || die "tests failed ${EPYTHON}"
	kill "${DBUS_SESSION_BUS_PID}"

	# Restore directory structure
	mv test Onboard/test || die
	mv Onboard/__init__.py.bak Onboard/__init__.py || die
}

src_install() {
	distutils-r1_src_install

	for doc in "${DOCS[@]}"; do
		rm "${ED}"/usr/share/"${PN}"/"${doc}" || die
	done
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}
