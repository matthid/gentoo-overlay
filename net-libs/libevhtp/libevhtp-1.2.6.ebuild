# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4

inherit eutils cmake-utils git-2

DESCRIPTION="Flexible replacement for libevent's httpd API"
HOMEPAGE="https://github.com/ellzey/libevhtp/"
# Trying to use this ebuild for all versions
MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	EGIT_REPO_URI="git://github.com/ellzey/libevhtp.git"
	KEYWORDS=
else
	SRC_URI="https://github.com/ellzey/libevhtp/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi
S=${WORKDIR}

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=dev-libs/libevent-2"

RDEPEND=""

if [ "$MAJOR" -eq "9999" ]
then
	src_unpack() {
		git-2_src_unpack
	}
fi
