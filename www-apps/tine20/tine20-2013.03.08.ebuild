# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/phpldapadmin/phpldapadmin-1.2.3.ebuild,v 1.1 2012/11/12 12:04:32 jmbsvicetto Exp $

EAPI="2"

inherit webapp depend.php git-2 elisp-common autotools dotnet eutils

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
		EGIT_BRANCH="$PV"
	fi
fi

#TODO: Check license
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
#TODO: Add other databases
IUSE="memcached mysql ldap logrotate"

RDEPEND="dev-lang/php[ctype,xml,simplexml,gd,iconv,json,crypt,zip]
		 mysql? (dev-lang/php[mysql,mysqli,pdo] dev-db/mysql)
		 memcached? ( dev-php/pecl-memcached net-misc/memcached )
		 ldap? (dev-lang/php[ldap])"

need_httpd_cgi
need_php_httpd

S="${S}/tine20"

src_prepare() {
	cp tine20/config.inc.php.dist tine20/config.inc.php
}

src_install() {
	webapp_src_preinst

	dodoc INSTALL

	# Restrict config file access
	chown root:apache "tine20/config.inc.php"
	chmod 640 "tine20/config.inc.php"

	insinto "${MY_HTDOCSDIR}"
	doins -r *

	webapp_configfile "${MY_HTDOCSDIR}/tine20/config.inc.php"
	webapp_postinst_txt en "${FILESDIR}"/postinstall2-en.txt

	webapp_src_install
}
