# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 autotools

DESCRIPTION="Libtpms-based TPM emulator with socket, character device, and Linux CUSE interface."
HOMEPAGE="https://github.com/stefanberger/swtpm"
SRC_URI=""
EGIT_REPO_URI="https://github.com/stefanberger/swtpm.git"
EGIT_BRANCH="stable-0.1.0"
LICENSE="BSD-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+ssl libressl"

DEPEND="
	dev-libs/libtpms
	sys-apps/gawk
	net-misc/socat
	dev-tcltk/expect
	ssl? (
	    !libressl? ( dev-libs/openssl )
		libressl? ( dev-libs/libressl )
	)"
RDEPEND="${DEPEND}"

src_prepare() {
   eapply_user
   eautoreconf
}

src_configure() {
	econf --with-openssl
}
