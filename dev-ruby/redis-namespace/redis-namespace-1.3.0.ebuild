# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Adds a Redis::Namespace class which can be used to namespace Redis keys."
HOMEPAGE="https://github.com/resque/redis-namespace"
SRC_URI="https://github.com/resque/redis-namespace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"
# tests try to connect to a local running redis server
# TODO: start a temporary one (preferably with a socket only)

ruby_add_rdepend "dev-ruby/redis"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' spec/spec_helper.rb || die "sed failed"
}
