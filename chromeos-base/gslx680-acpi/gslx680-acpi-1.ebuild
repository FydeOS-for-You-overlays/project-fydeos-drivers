# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit git-2 linux-info linux-mod

DESCRIPTION="ACPI/x86 compatible driver for Silead GSLx680 touchscreens"
HOMEPAGE="https://github.com/onitake/gslx680-acpi"

EGIT_REPO_URI="https://github.com/onitake/gslx680-acpi.git"
EGIT_BRANCH="master"
EGIT_COMMIT="667efcef2fa1fa6b24cd043ccb33b4a86a304ee6"

LICENSE="GPL-2"
KEYWORDS="-* amd64 x86"

RDEPEND="virtual/linux-sources"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

MODULE_NAMES="gslx680_ts_acpi(kernel/drivers/input/touchscreen)"

pkg_setup() {
	CONFIG_CHECK="!TOUCHSCREEN_SILEAD"
	ERROR_TOUCHSCREEN_SILEAD="This driver conflicts with the in-kernel silead driver as they both drive the same hardware."

	linux-mod_pkg_setup

	BUILD_PARAMS="KSRC=${KV_OUT_DIR} M=${S}"
	BUILD_TARGETS="modules"
}
