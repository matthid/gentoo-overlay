# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Created by Matthias Dittrich <matthi.d@gmail.com>

EAPI=4

inherit eutils python autotools versionator

DESCRIPTION="sinntp is a tiny non-interactive NNTP client "
HOMEPAGE="https://code.google.com/p/sinntp/"
COMMIT_ID="f10b71f338ce"
MAJOR=$(get_version_component_range 1)
if [ "$MAJOR" -eq "9999" ]
then
	#inherit git-2
	#EGIT_REPO_URI="git://github.com/haiwen/seafile.git"
	#KEYWORDS=
	#S=${WORKDIR}
else
	SRC_URI="https://sinntp.googlecode.com/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
fi

LICENSE="GPL-2"
SLOT="0"


#	dev-libs/jansson
DEPEND=">=dev-lang/python-2.5
	>=dev-python/python-support-0.90.0"

RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	if [ "$MAJOR" -eq "9999" ]
	then
		git-2_src_unpack
	else
	 	unpack ${A}
	fi

	cd "${S}"
}


src_install() {
	cd "doc/manpages"
	emake DESTDIR="${D}" install
	cd "${S}"
	mkdir -p "${D}/usr/share/sinntp"
	cp "plugins.py" "${D}/usr/share/sinntp"
	cp "sinntp" "${D}/usr/share/sinntp"
	cp "utils.py" "${D}/usr/share/sinntp"
	dobin "nntp-get" "nntp-list" "nntp-pull" "nntp-push" "sinntp"
	cd "doc"
	dodoc "NEWS" "mutt-integration.txt" "changelog" "changelog.old"
}
