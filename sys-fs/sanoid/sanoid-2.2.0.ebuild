# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Policy-driven snapshot management and replication tools for ZFS"
HOMEPAGE="https://www.openoid.net/products/"
SRC_URI="https://github.com/jimsalterjrs/sanoid/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="minimal"
# Tests require root privileges
RESTRICT="test"

RDEPEND="
	dev-lang/perl
	dev-perl/Capture-Tiny
	dev-perl/Config-IniFiles
	sys-fs/zfs
	virtual/ssh
	!minimal? (
		sys-apps/pv
		sys-block/mbuffer
	)
"

src_compile() { :; }

src_install() {
	dobin findoid
	dobin sanoid
	dobin sleepymutex
	dobin syncoid
	insinto "/etc/${PN}"
	doins sanoid.defaults.conf
	doins sanoid.conf
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
