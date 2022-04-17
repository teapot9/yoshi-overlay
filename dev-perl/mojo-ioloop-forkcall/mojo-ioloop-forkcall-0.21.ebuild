# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JBERGER"
DIST_NAME="Mojo-IOLoop-ForkCall"
inherit perl-module

DESCRIPTION="Run blocking functions asynchronously by forking"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Mojolicious
	dev-perl/mojo-ioloop-delay
	dev-perl/IO-Pipely
	virtual/perl-Perl-OSType
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-perl/Module-Build
"
