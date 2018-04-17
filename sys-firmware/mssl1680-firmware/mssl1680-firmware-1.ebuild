# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-2

DESCRIPTION="Firmware for silead mmsl1680 touchscreen"
HOMEPAGE="https://github.com/onitake/gsl-firmware"

EGIT_REPO_URI="https://github.com/onitake/gsl-firmware.git"
EGIT_BRANCH="master"
EGIT_COMMIT="ae83b2833546a146636bf442344ab51c2c7886d2"

LICENSE="GPL-3"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror binchecks strip"
SLOT="0"

DEPEND=""
RDEPEND=""

src_install() {
	insinto /lib/firmware
	doins firmware/cube/i1101/silead_ts.fw || die
}
