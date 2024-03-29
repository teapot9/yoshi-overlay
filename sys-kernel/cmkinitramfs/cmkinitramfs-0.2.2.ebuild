# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A customizable simple initramfs generator"
HOMEPAGE="https://github.com/teapot9/cmkinitramfs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyelftools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	app-arch/cpio
	sys-apps/busybox
	sys-apps/findutils
	sys-apps/kbd
	sys-apps/kmod
	sys-apps/linux-misc-apps
"
BDEPEND=""

DOCS=( README.rst config/cmkinitramfs.ini.example )

distutils_enable_sphinx doc/source dev-python/sphinx-rtd-theme

python_install_all() {
	distutils-r1_python_install_all

	# distutils can only install to /usr/bin
	local sbin_relocations=( cmkinit cmkcpiolist cmkcpiodir )
	einfo 'Moving admin scripts to sbin'
	dodir /usr/sbin
	for target in "${sbin_relocations[@]}"; do
		mv -v "${ED}/usr/bin/${target}" "${ED}/usr/sbin/${target}" \
			|| die 'sbin scripts move failed'
	done
}
