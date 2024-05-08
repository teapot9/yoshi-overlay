# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_11 )
PYTHON_REQ_USE="tk?"
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi desktop xdg-utils

DESCRIPTION="FUSE filesystem Python scripts for Nintendo console files"
HOMEPAGE="https://github.com/ihaveamac/ninfs"

LICENSE="MIT ISC"
SLOT="0/2"
KEYWORDS="~amd64"
IUSE="tk"

DEPEND="
	sys-fs/fuse:0
"
RDEPEND="${DEPEND}
	dev-python/haccrypto[${PYTHON_USEDEP}]
	dev-python/pyctr[${PYTHON_USEDEP}]
	dev-python/pypng[${PYTHON_USEDEP}]
"
IDEPEND="
	tk? ( dev-util/desktop-file-utils )
"

src_install() {
	distutils-r1_src_install

	if use tk; then
		for k in 16 32 64 128 1024; do
			newicon -s "${k}" "ninfs/gui/data/${k}x${k}.png" "${PN}.png"
		done
		make_desktop_entry "${PN}" "${PN}" "${PN}" 'System;Filesystem'
	else
		rm -vf "${ED}"/usr/bin/{ninfs,ninfsw} || die
	fi
}

pkg_postinst() {
	if use tk; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use tk; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
