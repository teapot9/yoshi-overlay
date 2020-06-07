# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="KBAUCOM"
inherit perl-module

DESCRIPTION="ASCII sprite animation framework"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/Curses"
DEPEND="${RDEPEND}"
