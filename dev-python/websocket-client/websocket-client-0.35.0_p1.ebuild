# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 vcs-snapshot

MY_PN=${PN//-/_}

DESCRIPTION="WebSocket client for python with hybi13 support"
HOMEPAGE="https://github.com/liris/websocket-client"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://pypi.python.org/packages/c1/f9/55f594d90ad9eeca0b615885e655519cecf280f8cd2e33304a680c95456a/websocket_client-0.35.0.tar.gz#md5=37015cccff457f841c6f21bae86fa2d0 -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]' 'python2*' )
"
src_unpack() {
    if [ "${A}" != "" ]; then
        unpack ${A}
    fi
	# websocket_client-0.35.0
	mv ${MY_PN}-0.35.0 ${P}
}

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
