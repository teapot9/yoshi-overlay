# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_TIMESTAMP="202207211651"

inherit java-pkg-2 java-utils-2

DESCRIPTION="Java language server"
HOMEPAGE="https://projects.eclipse.org/projects/eclipse.jdt.ls"
SRC_URI="https://download.eclipse.org/jdtls/milestones/${PV}/jdt-language-server-${PV}-${MY_TIMESTAMP}.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-1.1 Apache-2.0 BSD dom4j EPL-1.0 EPL-2.0 MIT MPL-1.1"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=""
DEPEND="${CP_DEPEND}"
RDEPEND="${CP_DEPEND}
	virtual/jre:17
"

QA_PREBUILT="${JAVA_PKG_JARDEST}/*.jar"

src_prepare() {
	sed -i -e 's|plugins/||g' config_{,ss_}linux/config.ini || die
	java-pkg-2_src_prepare
}

src_compile() { :; }

src_install() {
	java-pkg_dojar features/*.jar plugins/*.jar

	local jar="$(basename -- plugins/org.eclipse.equinox.launcher_*.jar)"
	[ -f "${ED}/${JAVA_PKG_JARDEST}/${jar}" ] \
		|| die "No jar file found for launcher (${jar})"
	local java_args=(
		-Declipse.application=org.eclipse.jdt.ls.core.id1
		-Dosgi.bundles.defaultStartLevel=4
		-Declipse.product=org.eclipse.jdt.ls.core.product
		-Xmx1G
	)
	java-pkg_dolauncher jdtls \
		--jar "${jar}" \
		--java_args "${java_args[*]}"

	insinto /etc
	newins config_linux/config.ini jdtls.ini
	newins config_ss_linux/config.ini jdtls_ss.ini
}
