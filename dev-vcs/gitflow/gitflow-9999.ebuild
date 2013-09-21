# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=5

inherit eutils versionator

DESCRIPTION="git-flow AVH Edition - automatic branching model for git."
HOMEPAGE="https://github.com/petervanderdoes/gitflow/wiki"

SLOT="0"
LICENSE="FreeBSD"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/petervanderdoes/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

# Trying to use this ebuild for all versions
MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	KEYWORDS=
	inherit git-2
	LIVE_EBUILD=true
	SRC_URI=
	EGIT_REPO_URI="https://github.com/petervanderdoes/gitflow.git"
else
	IUSE=""
	LIVE_EBUILD=false
	MY_PV=$PV
	MY_P="${PN}-${MY_PV}"
fi

RDEPEND="dev-vcs/git"

src_prepare() {
	# Fix prefix in makefile
	sed -i "s@prefix=/usr/local@prefix=${D}/usr@g" Makefile || die "Sed failed!"
}

#src_install() {
#	emake DESTDIR="${D}"
#	gitflow-installer.sh install stable;
#}
