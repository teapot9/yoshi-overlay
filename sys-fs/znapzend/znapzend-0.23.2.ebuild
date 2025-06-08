# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module autotools

DESCRIPTION="zfs backup with remote capabilities and mbuffer integration"
HOMEPAGE="https://www.znapzend.org/"
SRC_URI="https://github.com/oetiker/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Mojolicious
	dev-perl/mojo-log-clearable
	sys-fs/zfs
"
BDEPEND="
	dev-perl/Module-Build
	test? (
		${RDEPEND}
		dev-perl/Test-Exception
		dev-perl/Test-SharedFork
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.23.2-fix-thirdparty.patch"
	"${FILESDIR}/${PN}-0.22.0-fix-libdir.patch"
)

src_prepare() {
	perl-module_src_prepare
	eautoreconf --force --install --verbose --make
}

src_configure() {
	perl-module_src_configure
	econf
}

src_test() {
	emake check
}

src_install() {
	perl_set_version
	local myinst=( VENDOR_LIB="${VENDOR_LIB}" )
	perl-module_src_install
}
