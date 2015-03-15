# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/phpldapadmin/phpldapadmin-1.2.3.ebuild,v 1.1 2012/11/12 12:04:32 jmbsvicetto Exp $

EAPI="2"

inherit webapp depend.php eutils versionator

DESCRIPTION="Social website."
HOMEPAGE="http://friendica.com"



LICENSE="GPL-3"
#TODO: Add other databases
#IUSE="memcached mysql ldap"


# Trying to use this ebuild for all versions
MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	inherit git-2
	EGIT_REPO_URI="https://github.com/friendica/friendica.git"
	KEYWORDS=
	LIVE_EBUILD=true
else
	LIVE_EBUILD=false
	SRC_URI="https://github.com/friendica/friendica/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
fi

#	media-libs/gd[jpeg]
RDEPEND="
	dev-lang/php[unicode,mysql,gd,crypt,ssl,curl]
	"

need_httpd_cgi
need_php_httpd

#src_prepare() {
#	cp ${FILESDIR}/config.inc.php tine20/config.inc.php
#	use memcached && epatch "${FILESDIR}/config.inc.php.memcached.patch"
#}

src_install() {
	webapp_src_preinst

	dodoc "README"

	# Restrict config file access
	touch ".htconfig.php"
	chown root:apache ".htconfig.php"
	chmod 640 ".htconfig.php"

	cp -a "${S}/." "${D}${MY_HTDOCSDIR}"
#	mkdir -p "${D}/etc/logrotate.d"
#	cp "${FILESDIR}/tine20_logrotate" "${D}/etc/logrotate.d/tine20"
#	mkdir -p "${D}/var/lib/tine20/files"

	webapp_configfile "${MY_HTDOCSDIR}/.htconfig.php"
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_serverowned "${MY_HTDOCSDIR}/.htconfig.php"
	webapp_serverowned -R "${MY_HTDOCSDIR}/view/smarty3"
	webapp_src_install
}
