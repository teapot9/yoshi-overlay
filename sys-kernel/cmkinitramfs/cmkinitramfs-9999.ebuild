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

SBIN_EXECUTABLES=(
	'cmkinit'
	'cmkinitramfs'
)

python_install_all() {
	distutils-r1_python_install_all

	# distutils can only install to /usr/bin
	elog 'Moving scripts to sbin'
	dodir '/usr/sbin'
	for target in "${SBIN_EXECUTABLES[@]}"; do
		mv "${ED}/usr/bin/${target}" "${ED}/usr/sbin/${target}" || die 'sbin script move failed'
	done
}
