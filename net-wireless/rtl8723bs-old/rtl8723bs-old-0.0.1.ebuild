# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"
DESCRIPTION="realtek wifi driver for linux kernel 3.x"
EGIT_REPO_URI="git@gitlab.fydeos.xyz:drivers/realtek-wifi-kernel-3.git"
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

MODULE_NAMES="r8723bs(net/wireless)"

pkg_setup() {
    linux-mod_pkg_setup
    BUILD_TARGETS=modules
    BUILD_PARAMS="KSRC=${KV_OUT_DIR}"
}
