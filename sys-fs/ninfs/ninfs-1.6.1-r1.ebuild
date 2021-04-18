# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="FUSE filesystem Python scripts for Nintendo console files"
HOMEPAGE="https://github.com/ihaveamac/ninfs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	sys-fs/fuse:0
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	find "${S}" \( -name '*.py' -o -name '*.txt' \) -exec sed -i \
		-e 's:Cryptodome:Crypto:g' \
		-e 's:pycryptodomex:pycryptodome:g' \
		{} \; || die "Force use of pycryptodome"
	default
}
