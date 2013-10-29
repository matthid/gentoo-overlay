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

RDEPEND=""

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
		# ccnet dependency
		ccnet-init -c ${D}/var/lib/seafile/default/ccnet --name "gentoo-seafile" --port 10001 --host "seafile.$(hostname -d)"
		mkdir -p ${D}/etc/seafile
		mv ${D}/var/lib/seafile/default/ccnet/ccnet.conf ${D}/etc/seafile/ccnet.conf
		ln /etc/seafile/default/ccnet.conf "${D}/var/lib/seafile/default/ccnet/ccnet.conf"
		
		${D}/usr/bin/seaf-server-init --seafile-dir ${D}/var/lib/seafile/default/seafile-data --port 20001
		mv ${D}/var/lib/seafile/default/seafile-data/seafile.conf ${D}/etc/seafile/default/seafile.conf		
		ln /etc/seafile/default/seafile.conf "${D}/var/lib/seafile/default/seafile-data/seafile.conf"
		
		
		
	fi
	rm -rf ${D}/seafile
	rm -rf ${D}/seaserv
}


pkg_postinst() {
	elog
	if use server ; then
		elog 
		elog "Seafile server installed."
		elog "While we generated some default configuration for you"
		elog "it is highly recommended to edit those configuration files:"
		elog "- /etc/seafile/ccnet.conf ()"
		elog "Seafile server installed"
		elog "Seafile server installed"
		
	fi
}