# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module autotools

DESCRIPTION="zfs backup with remote capabilities and mbuffer integration"
HOMEPAGE="https://www.znapzend.org/"
SRC_URI="https://github.com/oetiker/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-perl/Mojolicious
	dev-perl/mojo-log-clearable
	virtual/perl-Scalar-List-Utils
"
RDEPEND="${DEPEND}
	sys-fs/zfs
"
BDEPEND="
	dev-perl/Module-Build
	test? (
		${RDEPEND}
		dev-perl/Test-Exception
		dev-perl/Test-SharedFork
		virtual/perl-Test
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.21.1-fix-thirdparty.patch"
	"${FILESDIR}/${PN}-0.21.1-fix-libdir.patch"
)

src_prepare() {
	perl-module_src_prepare
	eautoreconf --force --install --verbose --make
}

src_configure() {
	econf
	perl-module_src_configure
}

src_test() {
	emake check
}

src_install() {
	perl_set_version
	local myinst=( DESTDIR="${ED}" VENDOR_LIB="${VENDOR_LIB}" )
	perl-module_src_install
}
