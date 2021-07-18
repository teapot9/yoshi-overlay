# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="A customizable simple initramfs generator"
HOMEPAGE="https://github.com/teapot9/cmkinitramfs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/cpio
	app-arch/gzip
	app-arch/xz-utils
	app-misc/pax-utils
	sys-apps/busybox
	sys-apps/findutils
	sys-apps/kbd
"
BDEPEND=""

python_install_all() {
	distutils-r1_python_install_all

	# distutils can only install to /usr/bin
	local sbin_relocations=( cmkinit cmkinitramfs )
	einfo 'Moving admin scripts to sbin'
	dodir /usr/sbin
	for target in "${sbin_relocations[@]}"; do
		mv -v "${ED}/usr/bin/${target}" "${ED}/usr/sbin/${target}" \
			|| die 'sbin scripts move failed'
	done
}
