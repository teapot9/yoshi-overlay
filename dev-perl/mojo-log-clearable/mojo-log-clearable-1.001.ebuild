# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DBOOK"
DIST_NAME="Mojo-Log-Clearable"
inherit perl-module

DESCRIPTION="Mojo::Log with clearable log handle"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	dev-perl/Mojolicious
	dev-perl/Role-Tiny
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-perl/Module-Build-Tiny
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-Test
	)
"
