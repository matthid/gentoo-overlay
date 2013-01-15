# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools

DESCRIPTION="This is the F# compiler, core library and core tools (open source edition)."
HOMEPAGE="https://github.com/fsharp/${PN}"
SRC_URI="https://github.com/fsharp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
DEPEND="
	>=dev-lang/mono-2.10
	"
RDEPEND="${DEPEND}"

# S=${WORKDIR}/${P}

src_prepare() {
	#which autoreconf > /dev/null || (die "Please install autoconf");
	# on OSX autoconf may need a little help with these paths
	#aclocal -I /opt/local/share/aclocal -I /usr/local/share/aclocal 2> /dev/null
	
	#autoreconf || die "autoreconf"
	# epatch "${FILESDIR}/${PN}-update_makefile.patch"
	eautoreconf
	return
}

src_configure() {
	
		

	econf
	# No configure script, only a simple Makefile
	return
}
