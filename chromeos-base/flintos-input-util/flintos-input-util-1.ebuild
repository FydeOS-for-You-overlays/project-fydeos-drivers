# Copyright (c) 2017 The Flint OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Script to configure input devices for Flint OS"
HOMEPAGE="http://flintos.io"

SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="GPL-3"

IUSE+="psmouse_imps"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${D}

src_install() {
	dobin ${FILESDIR}/set-touchpad.sh

	# Only install this for vanilla, which sets psmouse.proto to imps for compatibility.
	# For other editions, users are required to run set-touchpad.sh if necessary.
	if use psmouse_imps; then
		insinto /etc/modprobe.d
		doins ${FILESDIR}/flintos-psmouse.conf
	fi
}
