# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4


RESTRICT_PYTHON_ABIS="3.*"
PYTHON_DEPEND="2"
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
	SRC_URI="https://github.com/haiwen/seafile/archive/v${PV}-server.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/seafile-${PV}-server"
fi

MYPATH="${S}/__PATH"



LICENSE="GPL-2"
SLOT="0"
IUSE="gtk server client python apache seahub"


#	dev-libs/jansson
DEPEND="dev-lang/python
	>=dev-libs/libevent-2.0
	>=dev-libs/glib-2.28
	>=dev-util/intltool-0.40
	sys-fs/fuse
	app-arch/libarchive
	>=dev-db/libzdb-2.12
	=net-libs/ccnet-${PV}
		dev-lang/vala:0.22
	dev-python/mako
	>=dev-db/sqlite-3.7:3
	sys-devel/libtool
	dev-libs/jansson
	seahub? (
	  >=dev-python/django-1.5
	  <dev-python/Djblets-0.7
	  dev-python/simplejson
	  virtual/python-imaging
	  dev-python/chardet
	  www-servers/gunicorn
	  dev-python/django-compressor
	  dev-python/six
	  dev-python/python-dateutil
	  dev-python/webpy
	)
	=net-libs/libevhtp-1.2.9[ssl,shared_build]
	sys-devel/gettext
	dev-util/pkgconfig"
# WARNING: BEFORE INCREASING THE libevhtp VERSION! Make sure, that after emerging with a higher number syncing still works (and seaf-server is not crashing)!


REQUIRED_USE="
	seahub? ( server )
	apache? ( seahub )"
RDEPEND="

	server? ( net-libs/ccnet[server] )
	python? ( net-libs/ccnet[python] )
	client? ( net-libs/ccnet[client] )
	apache? ( www-apache/mod_fastcgi )
	seahub? (
	  dev-python/python-dateutil
	  dev-python/flup
	  dev-python/pillow[jpeg]
	  dev-lang/python[sqlite]
	  dev-python/six
	)"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	if [ "$MAJOR" -eq "9999" ]
	then
		git-2_src_unpack
	else
		unpack ${A}
	fi

	cd "${S}"
	epatch "${FILESDIR}/seafile_2.1.3-seafile-controller.patch"
}

pkg_preinst() {
	if use server ; then
		# user for the seafile deamon
		enewuser seafile -1 /bin/bash /var/lib/seafile
		mkdir /var/lib/seafile/data
	fi
}

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

	econf $(use_enable gtk gui) \
		$(use_enable server) \
		$(use_enable client) \
		$(use_enable python) \
		--enable-console \
		|| die "econf failed"
}

src_compile() {
	ewarn "Parallel build disabled to prevent errors (broken)."
	emake -j1 || die "emake failed"

}

src_install() {
	emake DESTDIR="${D}" install


	if use server ; then
			if use seahub ; then
				newinitd "${FILESDIR}"/seafile_withseahub.initd seafile-server \
				 || die "Init script installation failed"
			else
			newinitd "${FILESDIR}"/seafile.initd seafile-server \
				 || die "Init script installation failed"
		fi

		# Configure default instance
		mkdir -p "${D}/var/lib/seafile/default"
		mv "${S}/scripts" "${D}/var/lib/seafile/default/seafile-server"
		ln /usr/bin/seafile "${D}/var/lib/seafile/default/seafile-server/seafile"


		cd "${D}/var/lib/seafile/default/seafile-server"
		if use seahub ; then
			wget https://github.com/haiwen/seahub/archive/v${PV}-server.tar.gz --output-document seahub.tar.gz
			tar xzf seahub.tar.gz
			mv seahub-${PV}-server seahub
			rm seahub.tar.gz
		fi

	fi

		# Prevent root /seafile directory...
		if [ -d ${D}/seafile ]; then
		   mkdir -p "${D}/var/lib/seafile/root"
		   mv ${D}/seafile "${D}/var/lib/seafile/root"
		fi

		# Prevent root /seaserv directory...
		if [ -d ${D}/seaserv ]; then
		   mkdir -p "${D}/var/lib/seaserv/root"
		   mv ${D}/seaserv "${D}/var/lib/seafile/root"
		fi

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
		elog "To setup your seafile instance with mysql run:"
		elog "su -s /bin/bash seafile"
		elog "cd /var/lib/seafile/default"
		elog "seafile-server/setup-seafile-mysql.sh"
		elog "NOTE: if you encounter errors delete the directories"
		elog "mentioned in the error message and run the commands above"
		elog
		elog "Start your seafile server with:"
		elog "etc/init.d/seafile-server start"
		elog
		elog "For reference see also:"
		elog "https://github.com/haiwen/seafile/wiki/Deploy-Seafile-with-apache"
		elog "https://github.com/haiwen/seafile/wiki/Download-and-Setup-Seafile-Server-with-MySQL"
		elog "https://github.com/haiwen/seafile/wiki/Configure-Seafile-to-use-LDAP"
		elog

		ewarn ""
		ewarn "IF YOU ARE UPGRADING FOLLOW THE OFFICIAL GUIDE (IE run the upgrade scripts now!)"
		ewarn "http://manual.seafile.com/deploy/upgrade.html"
		ewarn "You can find the upgrade scripts in /var/lib/seafile/default/seafile-server/upgrade/"
		ewarn ""
		ewarn "IF SYNCING DOES NOT WORK ANYMORE (after upgrading): "
		ewarn "(https://github.com/haiwen/seafile/issues/1119, https://github.com/haiwen/seafile/issues/512)"
		ewarn "try the following:"
		ewarn "  emerge --unmerge dev-libs/oniguruma"
		ewarn "  emerge -1 libevhtp seafile"
		ewarn "  rm /usr/include/onigposix.h"
		ewarn "  emerge -1 dev-libs/oniguruma"
	fi

	if ! use python; then
			ewarn "If you want to use the python scripts you should rebuild this package with the python use flag!"
	fi
}
