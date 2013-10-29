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
IUSE="gtk server client python"

DEPEND=">=dev-lang/python-2.5[sqlite]
	>=dev-python/django-1.5
	net-libs/ccnet
	dev-python/simplejson
	dev-python/mako
	dev-python/webpy
	<dev-python/Djblets-0.7
	dev-python/chardet
	www-servers/gunicorn
	net-libs/libevhtp
	sys-devel/gettext
	dev-util/pkgconfig"

RDEPEND="
	server? ( net-libs/ccnet[server] )
	python? ( net-libs/ccnet[python] )
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
		--enable-console \
		|| die "econf failed"
}

src_compile() {
	ewarn "parallel build is disabled for this package (build broken)."
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
		
		mkdir  "${D}/var/lib/seafile/default/seafile-server"
		cd "seafile-server"
		wget https://seafile.googlecode.com/files/seahub-1.8.1.tar.gz --output-document seahub.tar.gz
		tar xzf seahub.tar.gz
		mv seahub-1.8.1 seahub
		rm seahub.tar.gz
		
	fi
	mkdir -p "${D}/var/lib/seafile/default/seafile-server-${PV}"	
	mv "${S}/scripts/*" "${D}/var/lib/seafile/default/seafile-server-${PV}/"

	mkdir -p "${D}/var/lib/seafile/root"
	mv ${D}/seafile "${D}/var/lib/seafile/root"
	rm ${D}/seaserv "${D}/var/lib/seafile/root"
	chown -R seafile:seafile "${D}/var/lib/seafile"
}


pkg_postinst() {
	elog
	if use server ; then
		elog 
		elog "Seafile server installed."
		elog "To configure your seafile instance do:"
		elog "cd /var/lib/seafile/default"
		elog "su -s /bin/bash seafile"
		elog "seafile-admin setup"
		elog
		elog "To setup you seafile instance with mysql run:"
		elog "su -s /bin/bash seafile"
		elog "cd /var/lib/seafile/default"
		elog "../scripts/setup-seafile-mysql.sh"
		elog
		elog "Start your seafile server with:"
		elog "etc/init.d/seafile-server start"
		elog
		elog "For reference see also:"
		elog "https://github.com/haiwen/seafile/wiki/Deploy-Seafile-with-apache"
		elog "https://github.com/haiwen/seafile/wiki/Download-and-Setup-Seafile-Server-with-MySQL"
		elog 
		
	fi

	if ! use python; then
	     	ewarn "If you want to use the python scripts you should rebuild this package with the python use flag!"
	fi
}