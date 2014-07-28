# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Matthias Dittrich <matthi.d@gmail.com>

EAPI="4"

DESCRIPTION="Codeface Dependencies (for codeface development)"
HOMEPAGE="https://github.com/siemens/codeface"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# sinntp taken from ramereth overlay -> custom ebuild
# ctags -> custom ebuild
CDEPEND="dev-lang/R
	~dev-util/ctags-5.9_alpha_pre
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


