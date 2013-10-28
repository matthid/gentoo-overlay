# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Martin Kupec

EAPI=4

inherit eutils python autotools versionator

DESCRIPTION="Cloud file syncing software"
HOMEPAGE="http://www.seafile.com"

MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	inherit git-2
	EGIT_REPO_URI="git://github.com/haiwen/seafile.git"
	KEYWORDS=
else
# Wow they really don't have any naming convetions whatsoever

	SRC_URI="https://github.com/haiwen/seafile/archive/server-2.0.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi


S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk server httpserver client python"

DEPEND=">=dev-lang/python-2.5[sqlite]
	net-libs/ccnet
	dev-python/simplejson
	dev-python/mako
	dev-python/webpy
	dev-python/Djblets
	dev-python/chardet
	www-servers/gunicorn
	httpserver? ( net-libs/libevhtp )
	sys-devel/gettext
	dev-util/pkgconfig"

RDEPEND=""

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
if [ "$MAJOR" -eq "9999" ]
then
	src_unpack() {
		git-2_src_unpack
	}
fi

src_prepare() {
	./autogen.sh || die "Autogen failed"
}

src_configure() {
	econf $(use_enable gtk gui) \
		$(use_enable server) \
		$(use_enable client) \
		$(use_enable python) \
		$(use_enable httpserver) \
		--enable-console \
		|| die "econf failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}
