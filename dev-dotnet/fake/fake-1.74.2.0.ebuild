# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils mono
MY_PN="FAKE"

DESCRIPTION="FAKE - An integrated DSL for compiling and distributing projects"
HOMEPAGE="https://github.com/fsharp/${MY_PN}"
SRC_URI="https://github.com/fsharp/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="Ms-PL"
SLOT="0"
IUSE=""
#Because F# is only available with 2.10
DEPEND="
	>=dev-lang/mono-2.10.10
	dev-lang/fsharp"


RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	epatch "${FILESDIR}/mono_build.sh.patch"
}

src_configure() {
	# No configure script, only a simple Makefile
	return
}

src_compile() {
	cd $S
	./mono_build.sh || die "compile failed!"
}

src_install() {
	fakePath="${D}usr/lib/mono/fake/"
	# Create the path
	mkdir -p "${fakePath}"
	# Just copy FAKE.exe and FakeLib.dll to their destination
	cp build/FakeLib.dll "${fakePath}"
	cp build/FAKE.exe "${fakePath}"
	
	mkdir "${D}usr/bin"
	cp "${FILESDIR}/fake" "${D}usr/bin/fake"	
}
