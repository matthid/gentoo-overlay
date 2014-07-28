# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ctags/ctags-5.8.ebuild,v 1.11 2014/06/06 05:59:37 vapier Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Exuberant Ctags creates tags files for code browsing in editors"
HOMEPAGE="http://ctags.sourceforge.net"
SRC_URI="http://ftp.de.debian.org/debian/pool/main/e/exuberant-ctags/exuberant-ctags_5.9~svn20110310.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="go"

DEPEND="app-admin/eselect-ctags"
S="${WORKDIR}/ctags-5.9~svn20110310"

src_prepare() {
	epatch "${FILESDIR}/${PN}-5.6-ebuilds.patch"
	# Upstream fix for python variables starting with def

	# Bug #273697
	epatch "${FILESDIR}/${PN}-5.8-f95-pointers.patch"

	# Patches from debian: https://packages.debian.org/sid/exuberant-ctags
	epatch "${FILESDIR}/${P}-memmove.patch"
	epatch "${FILESDIR}/${P}-python-disable-imports.patch"
	epatch "${FILESDIR}/${P}-vim-command-loop.patch"
	# enabling Go support
	if use go ; then
		# cp "${WORKDIR}/${PN}-ada-mode-4.3.11/ada.c" "${S}" || die
		epatch "${FILESDIR}/${P}-go.patch"
	fi
}

src_configure() {
	econf \
		--with-posix-regex \
		--without-readlib \
		--disable-etags \
		--enable-tmpdir=/tmp
}

src_install() {
	emake prefix="${D}"/usr mandir="${D}"/usr/share/man install

	# namepace collision with X/Emacs-provided /usr/bin/ctags -- we
	# rename ctags to exuberant-ctags (Mandrake does this also).
	mv "${D}"/usr/bin/{ctags,exuberant-ctags} || die
	mv "${D}"/usr/share/man/man1/{ctags,exuberant-ctags}.1 || die

	dodoc FAQ NEWS README
	dohtml EXTENDING.html ctags.html
}

pkg_postinst() {
	eselect ctags update
	elog "You can set the version to be started by /usr/bin/ctags through"
	elog "the ctags eselect module. \"man ctags.eselect\" for details."
}

pkg_postrm() {
	eselect ctags update
}
