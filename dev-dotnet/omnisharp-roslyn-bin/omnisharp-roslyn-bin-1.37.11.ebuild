# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper

DESCRIPTION="OmniSharp server (HTTP, STDIO) based on Roslyn workspaces"
HOMEPAGE="https://github.com/OmniSharp/omnisharp-roslyn"
SRC_URI="
	stdio? ( https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${PV}/omnisharp-mono.tar.gz -> ${P}-stdio.tar.gz )
	http? ( https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${PV}/omnisharp.http-mono.tar.gz -> ${P}-http.tar.gz )
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug http +stdio"
REQUIRED_USE="|| ( http stdio )"

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/mono
	http? ( dev-libs/libuv )
"
BDEPEND=""

src_unpack() {
	unpack_subdir() {
		local dir="$(basename -- "${1}")"
		mkdir "${dir}" || die
		pushd "${dir}" >/dev/null || die
		unpack "${1}"
		popd >/dev/null || die
	}
	use stdio && unpack_subdir "${P}-stdio.tar.gz"
	use http && unpack_subdir "${P}-http.tar.gz"
}

src_prepare() {
	rename=(OmniSharp.deps.json OmniSharp.exe
		OmniSharp.exe.config OmniSharp.pdb)

	add_suffix() {
		pushd "${1}" >/dev/null || die
		for file in "${rename[@]}"; do
			new="${file/OmniSharp/OmniSharp${2}}"
			mv -v "${file}" "${new}" \
				|| die "mv ${file} ${new} failed"
		done
		popd >/dev/null || die
	}
	use stdio && add_suffix "${P}-stdio.tar.gz" .Stdio
	use http && add_suffix "${P}-http.tar.gz" .Http

	if ! use debug; then
		find . -type f -name '*.pdb' -delete
	fi

	default
}

src_install() {
	[ "${SLOT}" != 0 ] \
		&& local insdir="/usr/share/${PN}-${SLOT}" \
		|| local insdir="/usr/share/${PN}"

	insinto "${insdir}"
	install_subdir() {
		pushd "${1}" >/dev/null || die
		doins -r .
		popd >/dev/null || die
	}
	use stdio && install_subdir "${S}/${P}-stdio.tar.gz"
	use http && install_subdir "${S}/${P}-http.tar.gz"

	: "${MONO:=mono}"
	use stdio && make_wrapper omnisharp.stdio \
		"${MONO} ${EPREFIX}${insdir}/OmniSharp.Stdio.exe"
	use http && make_wrapper omnisharp.http \
		"${MONO} ${EPREFIX}${insdir}/OmniSharp.Http.exe"
}
