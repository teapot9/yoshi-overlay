# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_TIMESTAMP="202306011728"

inherit java-pkg-2

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

QA_PREBUILT="${JAVA_PKG_JARDEST}/*/*.jar"

src_compile() { :; }

launcher() {
	config="${1?}"
	name="${2?}"
	jar="${3?}"

	local java_args=(
		-Dfile.encoding=UTF-8
		-Declipse.application=org.eclipse.jdt.ls.core.id1
		-Dosgi.bundles.defaultStartLevel=4
		-Declipse.product=org.eclipse.jdt.ls.core.product
		-Dosgi.checkConfiguration=true
		-Dosgi.sharedConfiguration.area="${config}"
		-Dosgi.sharedConfiguration.area.readOnly=true
		-Dosgi.configuration.cascaded=true
		-Xms128M
		-Xmx2G
		--add-modules=ALL-SYSTEM
		--add-opens java.base/java.util=ALL-UNNAMED
		--add-opens java.base/java.lang=ALL-UNNAMED
	)
	java-pkg_dolauncher "${name}" \
		--jar "${jar}" \
		--java_args "${java_args[*]}"
}

src_install() {
	java-pkg_init_paths_
	base="${JAVA_PKG_JARDEST}"
	java-pkg_jarinto "${base}/features"
	java-pkg_dojar features/*.jar
	java-pkg_jarinto "${base}/plugins"
	java-pkg_dojar plugins/*.jar
	java-pkg_jarinto "${base}"

	local jar="$(basename -- plugins/org.eclipse.equinox.launcher_*.jar)"
	[ -f "${ED}/${base}/plugins/${jar}" ] \
		|| die "No jar file found for launcher (${jar})"
	launcher /etc/jdtls jdtls "${jar}"
	launcher /etc/jdtls_ss jdtls_ss "${jar}"

	insinto /etc/jdtls
	newins config_linux/config.ini config.ini
	insinto /etc/jdtls_ss
	newins config_ss_linux/config.ini config.ini
}
