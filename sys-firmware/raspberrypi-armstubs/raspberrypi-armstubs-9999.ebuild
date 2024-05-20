# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 mount-boot toolchain-funcs

DESCRIPTION="ARM stubs for the Raspberry PI"
HOMEPAGE="https://github.com/raspberrypi/tools"
EGIT_REPO_URI="https://github.com/raspberrypi/tools.git"
S="${WORKDIR}/${P}/armstubs"

LICENSE="BSD"
SLOT="0"
IUSE="cpu_flags_arm_v8 cpu_flags_arm_v7"

REQUIRED_USE="|| ( arm arm64 )"

get_stub_list() {
	if [ -n "${OVERRIDE_ARMSTUB_FILES}" ]; then
		echo "${OVERRIDE_ARMSTUB_FILES}"
		return
	fi
	if use arm; then
		if use cpu_flags_arm_v8; then
			echo "armstub8-32.bin"
			echo "armstub8-32-gic.bin"
		fi
		if use cpu_flags_arm_v7; then
			echo "armstub7.bin"
		fi
		echo "armstub.bin"
	fi
	if use arm64; then
		if use cpu_flags_arm_v8; then
			echo "armstub8.bin"
			echo "armstub8-gic.bin"
			echo "armstub8-gic-highperi.bin"
		fi
	fi
}

src_compile() {
	emake \
		CC7="$(tc-getCC)" \
		LD7="$(tc-getLD)" \
		OBJCOPY7="$(tc-getOBJCOPY)" \
		OBJDUMP7="$(tc-getOBJDUMP)" \
		CC8="$(tc-getCC)" \
		LD8="$(tc-getLD)" \
		OBJCOPY8="$(tc-getOBJCOPY)" \
		OBJDUMP8="$(tc-getOBJDUMP)" \
		$(get_stub_list)
}

src_install() {
	insinto "/boot"
	doins $(get_stub_list)
}
