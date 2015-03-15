# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Toolkit for building powerful command-line interfaces."
HOMEPAGE="https://github.com/erikhuda/thor"
SRC_URI="https://github.com/erikhuda/thor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/childlabor
	>=dev-ruby/fakeweb-1.3
	>=dev-ruby/rspec-2.11
	>=dev-ruby/rspec-mocks-2.12.2
	dev-ruby/simplecov
	)"

all_ruby_prepare() {
	# patch out useless bundler
	sed -i -e '/undler/d' ${PN}.gemspec Thorfile || die "sed failed"
	# patch out coveralls support to avoid dep cycle (coveralls-ruby requires thor again)
	sed -i -e '/overalls/d' spec/helper.rb || die "sed failed"
}
