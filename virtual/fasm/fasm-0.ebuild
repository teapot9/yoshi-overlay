# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for the flat assembler"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="|| (
		dev-lang/fasm
		dev-lang/fasm-bin
		dev-lang/fasmg
		dev-lang/fasmg-bin
	)"
