# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit git-r3 distutils-r1

DESCRIPTION="A customizable simple initramfs generator"
HOMEPAGE="https://github.com/lleseur/cmkinitramfs"
EGIT_REPO_URI="https://github.com/lleseur/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

python_install_all() {
	default

	# distutils can only install to /usr/bin
	elog 'Moving scripts to sbin'
	local sbinmove='cmkinit cmkinitramfs'
	dodir '/usr/sbin'
	for target in ${sbinmove}; do
		mv "${ED}/usr/bin/${target}" "${ED}/usr/sbin/${target}" || die 'sbin script move failed'
	done
}

