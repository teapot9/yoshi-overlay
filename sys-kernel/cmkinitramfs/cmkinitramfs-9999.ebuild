# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit git-r3 distutils-r1

DESCRIPTION="A customizable simple initramfs generator"
HOMEPAGE="https://github.com/teapot9/cmkinitramfs"
EGIT_REPO_URI="https://github.com/teapot9/${PN}.git"

LICENSE="MIT"
SLOT="0"

RDEPEND="${DEPEND}
	app-arch/cpio
	dev-python/pyelftools[${PYTHON_USEDEP}]
	sys-apps/busybox
	sys-apps/findutils
	sys-apps/kbd
	sys-apps/kmod
	sys-apps/linux-misc-apps
"

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
