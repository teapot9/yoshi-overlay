# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JBERGER"
DIST_NAME="Mojo-IOLoop-Delay"
inherit perl-module

DESCRIPTION="Promises/A+ and flow-control helpers"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Mojolicious
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-perl/Module-Build-Tiny
"
