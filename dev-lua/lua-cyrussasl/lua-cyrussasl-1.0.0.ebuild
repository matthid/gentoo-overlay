# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Cyrus SASL library for Lua 5.1"
HOMEPAGE="https://github.com/JorjBauer/${PN}"
SRC_URI="https://github.com/JorjBauer/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="
	>=dev-lang/lua-5.1
	dev-libs/cyrus-sasl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-update_makefile.patch"
}

src_configure() {
	append-flags "-I/usr/include/lua5.1 -fPIC -g"
	append-ldflags "-shared -fPIC -lsasl2"
	
	# No configure script, only a simple Makefile
	return
}
