# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="4"

inherit toolchain-funcs git-2

DESCRIPTION="rt8192bs bluetooth suppport"
HOMEPAGE="http://fydeos.com"

EGIT_REPO_URI="https://github.com/lwfinger/rtl8723bs_bt"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

src_compile() {
    emake || die "emake failed"
}

src_install() {
    exeinto /usr/sbin
    doexe rtk_hciattach
    insinto /lib/firmware/rtl_bt
    doins rtlbt_*
}
