# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/phpldapadmin/phpldapadmin-1.2.3.ebuild,v 1.1 2012/11/12 12:04:32 jmbsvicetto Exp $

EAPI="2"

inherit webapp depend.php git-2 eutils versionator

DESCRIPTION="GroupWare & CRM."
HOMEPAGE="http://www.tine20.org/home.html"
EGIT_REPO_URI="http://git.tine20.org/git/tine20"

# Trying to use this ebuild for all versions
MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	LIVE_EBUILD=true
else
	LIVE_EBUILD=false
	MY_PREVERSION=$(get_version_component_range 1-2)
	SERVICE_RELEASE_NO=$(get_version_component_range 3)
	# Check for live ebuild for a specific release for example "2013.03"
	if [ "$SERVICE_RELEASE_NO" -eq "9999" ]
	then
		MY_PV=$MY_PREVERSION
		MY_P="${PN}-${MY_PV}"
		EGIT_BRANCH="$MY_PREVERSION"
	else
		MY_PV=$PV
		MY_P="${PN}-${MY_PV}"
		# This is a TAG so it should not change
		EGIT_COMMIT="$PV"
	fi
fi

#TODO: Check license
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
#TODO: Add other databases
IUSE="memcached mysql ldap"

RDEPEND="dev-lang/php[ctype,xml,simplexml,gd,iconv,json,crypt,zip]
		 mysql? ( dev-lang/php[mysql,mysqli,pdo] dev-db/mysql )
		 memcached? ( dev-php/pecl-memcached net-misc/memcached )
		 ldap? ( dev-lang/php[ldap] )"

need_httpd_cgi
need_php_httpd

src_prepare() {
	cp ${FILESDIR}/config.inc.php tine20/config.inc.php
	use memcached && epatch "${FILESDIR}/config.inc.php.memcached.patch"
}

src_install() {
	webapp_src_preinst

	dodoc "README"

	# Restrict config file access
	chown root:apache "tine20/config.inc.php"
	chmod 640 "tine20/config.inc.php"

	cp -r "${S}/tine20/." "${D}${MY_HTDOCSDIR}"
	mkdir -p "${D}/etc/logrotate.d"
	cp "${FILESDIR}/tine20_logrotate" "${D}/etc/logrotate.d/tine20"
	mkdir -p "${D}/var/lib/tine20/files"

	webapp_configfile "${MY_HTDOCSDIR}/config.inc.php"
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_serverowned "${MY_HTDOCSDIR}/config.inc.php"
	webapp_serverowned -R "/var/lib/tine20"
	webapp_src_install
}
