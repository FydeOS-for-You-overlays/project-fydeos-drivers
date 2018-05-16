# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"
DESCRIPTION="ft5626 touch screen driver"
EGIT_REPO_URI="git@gitlab.fydeos.xyz:drivers/ft5626-touchcreen-driver.git"
EGIT_BRANCH="master"

inherit git-2 linux-info linux-mod

HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
    virtual/linux-sources
"

DEPEND="${RDEPEND}"

MODULE_NAMES="ft5x06_ts(input/touchscreen)"

pkg_setup() {
    linux-mod_pkg_setup
    BUILD_PARAMS="KSRC=${KV_OUT_DIR}"
    BUILD_TARGETS=modules
}
