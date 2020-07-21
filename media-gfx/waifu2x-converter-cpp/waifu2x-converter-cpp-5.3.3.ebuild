# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Fix test error: models_rgb/noise0_model.json not found
CMAKE_IN_SOURCE_BUILD=1
inherit cmake

DESCRIPTION="Improved fork of Waifu2X C++ using OpenCL and OpenCV"
HOMEPAGE="https://github.com/DeadSix27/waifu2x-converter-cpp"
SRC_URI="https://github.com/DeadSix27/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+executable +opencv cuda unicode +models debug test cpu_flags_x86_avx"

RESTRICT="!test? ( test )"
REQUIRED_USE="executable? ( opencv models )"
DEPEND="
	virtual/opencl
	>=media-libs/opencv-3
	opencv? ( >=media-libs/opencv-3[opencl] )
	cuda? ( dev-util/nvidia-cuda-toolkit )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=sys-devel/gcc-5
	test? ( opencv? ( media-libs/opencv[png] ) )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_UNICODE=$(usex unicode)
		-DENABLE_CUDA=$(usex cuda)
		-DINSTALL_MODELS=$(usex models)
		-DX86OPT=$(usex cpu_flags_x86_avx)
		$(usex cuda '-DCUDA_TOOLKIT_ROOT_DIR=""' "")
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DENABLE_TESTS=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	use executable || elog "You only installed the library, enable the executable useflag to install it."
}
