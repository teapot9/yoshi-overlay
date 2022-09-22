# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Android audio forwarding"
HOMEPAGE="https://github.com/rom1v/sndcpy"
SRC_URI="
	https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-v1.1.zip
	https://github.com/rom1v/sndcpy/archive/refs/tags/v1.1.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	dev-util/android-tools
	media-video/vlc
"
BDEPEND="
	app-arch/unzip
"

src_prepare() {
	eapply_user
	sed -i -e "s|sndcpy.apk|${EPREFIX}/usr/share/sndcpy/sndcpy.apk|g" \
		sndcpy || die
}

src_compile() { :; }

src_install() {
	einstalldocs
	dobin sndcpy
	insinto /usr/share/sndcpy
	doins "${WORKDIR}/sndcpy.apk"
}

pkg_postinst() {
	elog 'You may need udev rules to use sndcpy as an unprivileged user.'
	elog '1. Get your device "vendor:product" ID with `lsusb`.'
	elog '2. Add a rule in /etc/udev/rules.d/51-android.rules:'
	elog '   SUBSYSTEM=="usb", ATTR{idVendor}=="XXXX", ATTR{idProduct}=="XXXX", TAG+="uaccess"'
	elog '3. Reboot or reload udev with:'
	elog '   # udevadm control --reload-rules && udevadm trigger --attr-match=subsystem=usb'
}
