# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="FUSE filesystem Python scripts for Nintendo console files"
HOMEPAGE="https://github.com/ihaveamac/ninfs"

LICENSE="MIT openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	sys-fs/fuse:0
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-include.patch"
)

src_prepare() {
	find "${S}" \( -name '*.py' -o -name '*.txt' \) -exec sed -i \
		-e 's:Cryptodome:Crypto:g' \
		-e 's:pycryptodomex:pycryptodome:g' \
		{} \; || die "Force use of pycryptodome"
	default
}
