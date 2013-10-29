# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4

inherit eutils python autotools versionator

DESCRIPTION="Cloud file syncing software"
HOMEPAGE="http://www.seafile.com"

MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	inherit git-2
	EGIT_REPO_URI="git://github.com/haiwen/seafile.git"
	KEYWORDS=
	S=${WORKDIR}
else
# Wow they really don't have any naming convetions whatsoever

	SRC_URI="https://github.com/haiwen/seafile/archive/server-2.0.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/seafile-server-${PV}"
fi




LICENSE="GPL-2"
SLOT="0"
IUSE="gtk server httpserver client python"

DEPEND=">=dev-lang/python-2.5[sqlite]
	net-libs/ccnet
	dev-python/simplejson
	dev-python/mako
	dev-python/webpy
	dev-python/Djblets
	dev-python/chardet
	www-servers/gunicorn
	httpserver? ( net-libs/libevhtp )
	sys-devel/gettext
	dev-util/pkgconfig"

RDEPEND="
	server? ( net-libs/ccnet[server] )
	client? ( net-libs/ccnet[client] )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
if [ "$MAJOR" -eq "9999" ]
then
	src_unpack() {
		git-2_src_unpack
	}
fi

pkg_preinst() {
	if use server ; then
		# user for the seafile deamon
		enewuser seafile -1 /bin/bash /var/lib/seafile
		mkdir /var/lib/seafile/data
	fi
}

src_prepare() {
	./autogen.sh || die "Autogen failed"
}

src_configure() {
	econf $(use_enable gtk gui) \
		$(use_enable server) \
		$(use_enable client) \
		$(use_enable python) \
		$(use_enable httpserver) \
		--enable-console \
		|| die "econf failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install
	
	if use server ; then
		newinitd "${FILESDIR}"/seafile.initd seafile-server \
			|| die "Init script installation failed"
			
		# Configure default instance
		
		mkdir -p ${D}/var/lib/seafile/default
		cd ${D}/var/lib/seafile/default
		
		mkdir -p ${D}/etc/seafile
		touch ${D}/etc/seafile/ccnet.conf
		ln /etc/seafile/default/ccnet.conf "${D}/var/lib/seafile/default/ccnet/ccnet.conf"
		
		touch ${D}/etc/seafile/default/seafile.conf		
		ln /etc/seafile/default/seafile.conf "${D}/var/lib/seafile/default/seafile-data/seafile.conf"
		
		mkdir  "${D}/var/lib/seafile/default/seafile-server"
		cd "seafile-server"
		wget https://seafile.googlecode.com/files/seahub-1.8.1.tar.gz --output-document seahub.tar.gz
		tar xzf seahub.tar.gz
		mv seahub-1.8.1 seahub
		rm seahub.tar.gz
		
	fi
	rm -rf ${D}/seafile
	rm -rf ${D}/seaserv
}


pkg_postinst() {
	elog
	if use server ; then
		elog 
		elog "Seafile server installed."
		elog "You have to run \"seafile-admin setup\" in the /var/lib/seafile/default/ directory as seafile user"
		elog "After that you can still edit your config in"
		elog "/etc/seafile/default/"
		elog "After configuration setup apache: https://github.com/haiwen/seafile/wiki/Deploy-Seafile-with-apache"
		elog "If you want you can use mysql: https://github.com/haiwen/seafile/wiki/Download-and-Setup-Seafile-Server-with-MySQL"
		elog "After all the steps above you can start your server with \"/etc/init.d/seafile-server start\""
		elog 
		
	fi
}