# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Matthias Dittrich <matthi.d@gmail.com>

EAPI="4"

DESCRIPTION="K Version Manager (KVM) bootstrapping package."
HOMEPAGE="https://github.com/graemechristie/Home/tree/KvmShellImplementation"
# Make sure to get the "correct" file, manifest checksum will take care of this.
SRC_URI="https://raw.githubusercontent.com/graemechristie/Home/KvmShellImplementation/kvmsetup.sh -> ${P}-setup.sh"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

CDEPEND="net-misc/curl
	app-arch/unzip
	>=dev-lang/mono-3.4.1"
	
RDEPEND="${CDEPEND}"

DEPEND="${CDEPEND}"


src_unpack() {
    mkdir -p "${S}"
    cp "/usr/portage/distfiles/${A}" "${S}/kvmsetup.sh"
    chmod +x "${S}/kvmsetup.sh"
}

src_prepare() {
    true;
}

src_configure() {
    true;
}
src_compile() {
    true;
}
src_test() {
    true;
}
src_install() {
    mkdir -p "${ED}/var/lib/kvm-runtime"
    cp "kvmsetup.sh" "${ED}/var/lib/kvm-runtime"
}

pkg_postinst() {
    elog "To install kvm for the current user execute:"
    elog "/var/lib/kvm-runtime/kvmsetup.sh && source ~/.kre/kvm/kvm.sh && kvm upgrade"

}








