# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Policy-driven snapshot management and replication tools for ZFS"
HOMEPAGE="http://www.openoid.net/products/"
SRC_URI="https://github.com/jimsalterjrs/sanoid/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
# Tests require root privileges
RESTRICT="test"

DEPEND="
	dev-perl/Config-IniFiles
	dev-perl/Capture-Tiny
	virtual/perl-Data-Dumper
"
RDEPEND="${DEPEND}
	sys-apps/pv
	sys-block/mbuffer
"
BDEPEND=""

DOCS=( README.md sanoid.conf )

src_test() {
	cd tests
	./run-tests.sh || die "run-tests.sh failed"
}

src_install() {
	dobin findoid
	dobin sanoid
	dobin sleepymutex
	dobin syncoid
	insinto "/etc/${PN}"
	doins sanoid.defaults.conf
	insinto /etc/cron.d
	newins "${FILESDIR}/${PN}.cron" "${PN}"
	einstalldocs
}

pkg_postinst() {
	optfeature_header "Install optional compression backends for replication:"
	optfeature "pigz compression" app-arch/pigz
	optfeature "zstd compression" app-arch/zstd
	optfeature "lzo compression" app-arch/lzop
	optfeature "lz4 compression" app-arch/lz4
}
