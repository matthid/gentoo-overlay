# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/redmine/redmine-2.4.6.ebuild,v 1.2 2014/08/06 00:06:01 mrueg Exp $

EAPI=5
inherit eutils user

DESCRIPTION="Redmine is a flexible project management web application written using Ruby on Rails framework"
HOMEPAGE="http://www.redmine.org/"
#SRC_URI="http://www.redmine.org/releases/${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="GPL-2"
SLOT="0"
# All db-related USEs are ineffective since we depend on rails
# which depends on activerecord which depends on all ruby's db bindings
#IUSE="ldap openid imagemagick postgres sqlite mysql fastcgi passenger"
#IUSE="ldap imagemagick fastcgi passenger"
IUSE="ldap passenger"

DEPEND="dev-libs/icu media-gfx/imagemagick
virtual/ruby-ssl
virtual/rubygems
<dev-ruby/rails-5
dev-ruby/rake
passenger? ( www-apache/passenger )"
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
