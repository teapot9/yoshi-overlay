# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NP2kai is PC-9801 series emulator"
HOMEPAGE="https://github.com/AZO234/NP2kai"
SRC_URI="https://github.com/AZO234/NP2kai/archive/rev.${PV}.tar.gz"
S="${WORKDIR}/NP2kai-rev.${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X sdl1 i286"

# SDL1 currently not supported
REQUIRED_USE="gcw0? ( !X !libretro )
	libretro? ( !X !gcw0 )
	!sdl1"
DEPEND="X? ( x11-libs/gtk+:2 virtual/libusb )
	sdl1? ( media-libs/libsdl media-libs/sdl-ttf media-libs/sdl-mixer )
	!sdl1? ( media-libs/libsdl2 media-libs/sdl2-ttf media-libs/sdl2-mixer )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	eapply "${FILESDIR}/${PV}/${P}-fix-sdl2-makefile.patch"
	eapply "${FILESDIR}/${PV}/${P}-fix-sdl2-makefile21.patch"

	eapply_user
}

src_configure() {
	if use X; then
		cd ./x11
		./autogen.sh
		if ! use sdl1 && ! use i286; then
			econf --enable-ia32 || die "econf failed"
		elif ! use sdl1 && use i286; then
			econf || die "econf failed"
		elif use sdl1 && ! use i286; then
			econf --enable-sdl --enable-sdlmixer --enable-sdlttf --enable-sdl2=no --enable-sdl2mixer=no --enable-sdl2ttf=no --enable-ia32 || die "econf failed"
		elif use sdl1 && use i286; then
			econf --enable-sdl --enable-sdlmixer --enable-sdlttf --enable-sdl2=no --enable-sdl2mixer=no --enable-sdl2ttf=no || die "econf failed"
		fi
	fi
}

src_compile() {
	if use X; then
		cd ./x11
		emake || die "emake failed"
	else
		cd ./sdl2
		if ! use sdl1 && ! use i286; then
			emake -f Makefile21.unix || die "emake failed"
		elif ! use sdl1 && use i286; then
			emake -f Makefile.unix || die "emake failed"
		elif use sdl1 && ! use i286; then
			emake -f Makefile21.unix SDL_VERSION=1 || die "emake failed"
		elif use sdl1 && use i286; then
			emake -f Makefile.unix SDL_VERSION=1 || die "emake failed"
		fi
	fi
}

src_install() {
	if use X; then
		cd ./x11
		emake DESTDIR="${D}" install || die "emake install failed"
	else
		cd ./sdl2
		if ! use i286; then
			emake -f Makefile21.unix DESTDIR="${D}" prefix="/usr" install || die "emake install failed"
		else
			emake -f Makefile.unix DESTDIR="${D}" prefix="/usr" install || die "emake install failed"
		fi
	fi
	einstalldocs
}
