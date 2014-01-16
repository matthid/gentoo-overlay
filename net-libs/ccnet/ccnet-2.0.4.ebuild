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
	SRC_URI="https://github.com/haiwen/ccnet/archive/v${PV}-server.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/ccnet-${PV}-server"
fi

MYPATH="${S}/__PATH"

SLOT="0"
LICENSE="GPL-2"
IUSE="demo client server python cluster ldap mysql"

DEPEND="=net-libs/libsearpc-${PV}
	>=dev-libs/glib-2.0
	dev-lang/vala:0.22
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
	export VALAC="$(type -P valac-0.22)" 
	mkdir -p ${MYPATH}
	ln -s "$VALAC" "${MYPATH}/valac"
	export PATH="${MYPATH}:${PATH}"
	
	./autogen.sh || die "Autogen failed"
}


src_configure() {
	export VALAC="$(type -P valac-0.22)"
	export PATH="${MYPATH}:${PATH}" 
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

src_compile() {
# parallel build broken :( 
  	ewarn "parallel build is disabled for this package (broken)."
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install


	# Prevent root /ccnet directory...
	if [ -d ${D}/ccnet ]; then
	   mkdir -p "${D}/var/lib/seafile/root"
           mv ${D}/ccnet "${D}/var/lib/seafile/root"
	fi

#	mkdir -p "${D}/var/lib/seafile/default/seafile-server/seafile-server-${PV}"
#	mv "${S}" "${D}/var/lib/seafile/default/seafile-server/seafile-server-${PV}/ccnet"
}