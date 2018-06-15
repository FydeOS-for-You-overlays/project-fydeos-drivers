# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="4"

DESCRIPTION="firmware for silead/mssl1680"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
    insinto /lib/firmware/silead
    doins ${FILESDIR}/mssl1680.fw
}
