# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Matthias Dittrich <matthi.d@gmail.com>

EAPI="4"

#S="${WORKDIR}/org.eclipse.linuxtools.eclipse-build-${ECLIPSE_BUILD_VER}/eclipse-build"

DESCRIPTION="Codeface Dependencies (for codeface development)"
HOMEPAGE="https://github.com/siemens/codeface"
SRC_URI=""
#"${BASE_URI}eclipse-${BUILD_VER}-src.tar.bz2
#	http://git.eclipse.org/c/linuxtools/org.eclipse.linuxtools.eclipse-build.git/snapshot/org.eclipse.linuxtools.eclipse-build-${ECLIPSE_BUILD_VER}.tar.bz2 -> eclipse-build-${ECLIPSE_BUILD_VER}.tar.bz2"
#	${BASE_URI}eclipse-build-${ECLIPSE_BUILD_VER}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# echo "needs ramereth (layman overlay)"
# sinntp (not in portage, did not found it in an overlay -> custom ebuild)
CDEPEND="dev-lang/R
	dev-db/mysql
	>=dev-db/mysql-workbench-6.0.0
	net-libs/nodejs
	>=media-gfx/graphviz-2.30
	>=net-misc/sinntp-1.5.1
	app-text/texlive
	virtual/jdk
	dev-python/pip
	app-text/sloccount
	media-libs/mesa[gles2]
	app-text/poppler
	dev-libs/libyaml"
	
RDEPEND="${CDEPEND}"

DEPEND="${CDEPEND}"


