# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4

inherit eutils autotools python versionator

DESCRIPTION="Networking library for Seafile"
HOMEPAGE="http://www.seafile.com"

# Trying to use this ebuild for all versions
MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	inherit git-2
	EGIT_REPO_URI="git://github.com/haiwen/ccnet.git"
	KEYWORDS=
	S=${WORKDIR}
else
	SRC_URI="https://github.com/haiwen/ccnet/archive/server-2.0.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/ccnet-server-${PV}"
fi

SLOT="0"
LICENSE="GPL-2"
IUSE="demo client server python cluster ldap mysql"

DEPEND="net-libs/libsearpc
	>=dev-libs/glib-2.0
	>=dev-lang/vala-0.8
	dev-db/libzdb
	dev-util/pkgconfig"

RDEPEND=""

if [ "$MAJOR" -eq "9999" ]
then
	src_unpack() {
	     git-2_src_unpack
	}
fi
 

src_prepare() {
	./autogen.sh || die "Autogen failed"
}


src_configure() {
	econf $(use_enable demo compile-demo) \
		$(use_enable server) \
		$(use_enable client) \
		$(use_enable python) \
		$(use_enable cluster) \
		$(use_enable ldap) \
		$(use_enable mysql) \
		--enable-console \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install
	
	
	
	rm -rf ${D}/ccnet
}