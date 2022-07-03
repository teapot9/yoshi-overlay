# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.16.0
	adler-1.0.2
	always-assert-0.1.2
	ansi_term-0.12.1
	anyhow-1.0.44
	anymap-0.12.1
	arbitrary-1.0.2
	arrayvec-0.7.1
	atty-0.2.14
	autocfg-1.0.1
	backtrace-0.3.61
	bitflags-1.3.2
	camino-1.0.5
	cargo-platform-0.1.2
	cargo_metadata-0.14.0
	cc-1.0.71
	cfg-if-1.0.0
	chalk-derive-0.71.0
	chalk-ir-0.71.0
	chalk-recursive-0.71.0
	chalk-solve-0.71.0
	countme-2.0.4
	cov-mark-2.0.0-pre.1
	crc32fast-1.2.1
	crossbeam-channel-0.5.1
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.5
	crossbeam-utils-0.8.5
	dashmap-4.0.2
	derive_arbitrary-1.0.2
	dissimilar-1.0.3
	dot-0.1.4
	drop_bomb-0.1.5
	either-1.6.1
	ena-0.14.0
	expect-test-1.2.0-pre.1
	filetime-0.2.15
	fixedbitset-0.2.0
	flate2-1.0.22
	form_urlencoded-1.0.1
	fs_extra-1.2.0
	fsevent-sys-4.0.0
	fst-0.4.7
	gimli-0.25.0
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	home-0.5.3
	idna-0.2.3
	indexmap-1.7.0
	inotify-0.9.5
	inotify-sys-0.1.5
	instant-0.1.11
	itertools-0.10.1
	itoa-0.4.8
	jod-thread-0.1.2
	kqueue-1.0.4
	kqueue-sys-1.0.3
	lazy_static-1.4.0
	libc-0.2.103
	libloading-0.7.1
	libmimalloc-sys-0.1.22
	lock_api-0.4.5
	log-0.4.14
	lsp-server-0.5.2
	lsp-types-0.91.0
	matchers-0.0.1
	matches-0.1.9
	memchr-2.4.1
	memmap2-0.5.0
	memoffset-0.6.4
	mimalloc-0.1.26
	miniz_oxide-0.4.4
	mio-0.7.13
	miow-0.3.7
	notify-5.0.0-pre.13
	ntapi-0.3.6
	num_cpus-1.13.0
	object-0.26.2
	once_cell-1.8.0
	oorandom-11.1.3
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-1.0.5
	percent-encoding-2.1.0
	perf-event-0.4.7
	perf-event-open-sys-1.0.1
	petgraph-0.5.1
	pin-project-lite-0.2.7
	proc-macro2-1.0.30
	pulldown-cmark-0.8.0
	pulldown-cmark-to-cmark-6.0.4
	quote-1.0.10
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.10
	regex-1.5.4
	regex-automata-0.1.10
	regex-syntax-0.6.25
	rowan-0.14.1
	rustc-ap-rustc_lexer-725.0.0
	rustc-demangle-0.1.21
	rustc-hash-1.1.0
	ryu-1.0.5
	salsa-0.17.0-pre.2
	salsa-macros-0.17.0-pre.2
	same-file-1.0.6
	scoped-tls-1.0.0
	scopeguard-1.1.0
	semver-1.0.4
	serde-1.0.130
	serde_derive-1.0.130
	serde_json-1.0.68
	serde_repr-0.1.7
	sharded-slab-0.1.4
	smallvec-1.7.0
	smol_str-0.1.18
	snap-1.0.5
	syn-1.0.80
	synstructure-0.12.6
	termcolor-1.1.2
	text-size-1.1.0
	thread_local-1.1.3
	threadpool-1.8.1
	tikv-jemalloc-ctl-0.4.2
	tikv-jemalloc-sys-0.4.2+5.2.1-patched.2
	tikv-jemallocator-0.4.1
	tinyvec-1.5.0
	tinyvec_macros-0.1.0
	tracing-0.1.29
	tracing-attributes-0.1.18
	tracing-core-0.1.21
	tracing-log-0.1.2
	tracing-subscriber-0.2.25
	tracing-tree-0.1.10
	ungrammar-1.14.9
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-xid-0.2.2
	url-2.2.2
	version_check-0.9.3
	walkdir-2.3.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	write-json-0.1.2
	xflags-0.2.3
	xflags-macros-0.2.3
	xshell-0.1.17
	xshell-macros-0.1.17
"

inherit cargo

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rust-lang/rust-analyzer"
else
	KEYWORDS="~amd64"
	MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"
	SRC_URI="https://github.com/rust-lang/rust-analyzer/archive/${MY_PV}.tar.gz -> ${P}.tar.gz $(cargo_crate_uris)"
fi

DESCRIPTION="An implementation of Language Server Protocol for the Rust programming language"
HOMEPAGE="https://rust-analyzer.github.io"

LICENSE="0BSD Apache-2.0 Artistic-2 BSD Boost-1.0 CC0-1.0 ISC MIT Unlicense ZLIB"
RESTRICT="mirror"
SLOT="0"
IUSE=""

DEPEND="|| ( >=dev-lang/rust-1.55.0[rls] >=dev-lang/rust-bin-1.55.0[rls] )"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
		mv -T "${PN}-${MY_PV}" "${P}" || die
	fi
}

src_install() {
	cargo_src_install --path "./crates/rust-analyzer"
}
