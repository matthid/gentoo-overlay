# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changes.md README.md"
# TODO: examples

inherit ruby-fakegem

DESCRIPTION="Simple, efficient background processing for Ruby"
HOMEPAGE="https://github.com/mperham/sidekiq"
SRC_URI="https://github.com/mperham/sidekiq/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"
# most of the tests try to connect to a locally running redis-server (again)

ruby_add_rdepend "
	>=dev-ruby/redis-3
	dev-ruby/redis-namespace
	>=dev-ruby/connection_pool-1.0.0
	>=dev-ruby/celluloid-0.14.1
	dev-ruby/json"

ruby_add_bdepend "test? (
		dev-ruby/sinatra
		>=dev-ruby/slim-1.1
		>=dev-ruby/minitest-5
		dev-ruby/actionmailer
		dev-ruby/activerecord )"

all_ruby_prepare() {
	sed -i -e '/coveralls/,+3d' test/helper.rb || die "sed failed"
}
