# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NP2kai is PC-9801 series emulator"
HOMEPAGE="https://github.com/AZO234/NP2kai"
SRC_URI="https://github.com/AZO234/${PN}/archive/rev.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rev.${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X +ia32 libretro"

# SDL1 currently not supported
REQUIRED_USE="libretro? ( !X ia32 )"
DEPEND="
	X? ( x11-libs/gtk+:2 virtual/libusb )
	media-libs/libsdl2
	media-libs/sdl2-ttf
	media-libs/sdl2-mixer
"
RDEPEND="${DEPEND}"
BDEPEND="X? ( sys-devel/automake )"

PATCHES=(
	"${FILESDIR}/${P}-fix-sdl2-makefile.patch"
	"${FILESDIR}/${P}-fix-sdl2-makefile21.patch"
)

src_configure() {
	if use X; then
		cd ./x11
		./autogen.sh
		econf $(use_enable ia32)
	fi
}

src_compile() {
	if use X; then
		cd ./x11
		emake || die "emake failed"
	elif ! use libretro; then
		cd ./sdl2
		emake $(usex ia32 '-f Makefile.unix' '-f Makefile21.unix') || die "emake failed"
	else
		cd ./sdl2
		emake || die "emake failed"
	fi
}

src_install() {
	if use X; then
		cd ./x11
		emake DESTDIR="${ED}" install || die "emake install failed"
	elif ! use libretro; then
		cd ./sdl2
		emake \
			$(usex ia32 '-f Makefile.unix' '-f Makefile21.unix') \
			DESTDIR="${ED}" \
			prefix="/usr" \
			install || die "emake install failed"
	else
		cd ./sdl2
		emake \
			DESTDIR="${ED}" \
			libdir="/usr/lib" \
			LIBRETRO_DIR="libretro" \
			install || die "emake install failed"
	fi
	einstalldocs
}
