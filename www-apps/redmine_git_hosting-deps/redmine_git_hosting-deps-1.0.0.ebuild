# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/redmine/redmine-2.4.6.ebuild,v 1.2 2014/08/06 00:06:01 mrueg Exp $

EAPI=5
inherit eutils user

DESCRIPTION="Redmine git hosting is a git plugin for redmine"
HOMEPAGE="http://jbox-web.github.io/redmine_git_hosting/"
#SRC_URI="http://www.redmine.org/releases/${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="GPL-2"
SLOT="0"
# All db-related USEs are ineffective since we depend on rails
# which depends on activerecord which depends on all ruby's db bindings
#IUSE="ldap openid imagemagick postgres sqlite mysql fastcgi passenger"
#IUSE="ldap imagemagick fastcgi passenger"

DEPEND="net-libs/libssh2 dev-util/cmake dev-libs/libgpg-error"
RDEPEND="$DEPEND"

pkg_setup() {
	:
}

all_ruby_prepare() {
	:
}


all_ruby_install() {
	:
}

pkg_postinst() {
	:
}

pkg_config() {
	:
}
