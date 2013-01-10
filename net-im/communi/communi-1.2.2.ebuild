# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2
[[ ${PV} = *9999* ]] && VCS_ECLASS="git-2" || VCS_ECLASS=""

DESCRIPTION="A cross-platform IRC framework written with Qt 4"
HOMEPAGE="https://github.com/communi/communi"
if [[ ${PV} == *9999* ]]; then
      	EGIT_REPO_URI="git://github.com/communi/communi.git"
else
	SRC_URI="https://github.com/communi/communi/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icu test"

COMMON_DEPEND="icu? ( dev-libs/icu )"
DEPEND="${COMMON_DEPEND}
	test? ( x11-libs/qt-test )"
RDEPEND="${COMMON_DEPEND}"

src_unpack() {
	     base_src_unpack
	     mv "${WORKDIR}"/communi-communi-* "${WORKDIR}/${P}" || die
}

src_prepare() {
	      use test || { sed -i -e '/SUBDIRS += tests/d' communi.pro || die; }
	      qt4-r2_src_prepare
}

src_configure() {
		eqmake4 communi.pro $(use icu || echo "-config no_icu")
}