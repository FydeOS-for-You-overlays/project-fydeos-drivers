# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs unpacker

DESCRIPTION="Intel 3A library binaries required by the Intel camera HAL"
SRC_URI="gs://chromeos-localmirror/distfiles/intel-3a-libs-bin-${PV}.tbz2"

LICENSE="LICENSE.intel_3a_library"
SLOT="0"
KEYWORDS="-* amd64"

S="${WORKDIR}"

src_install() {
	insinto /usr/$(get_libdir)
	dolib.so usr/$(get_libdir)/*.so*

	insinto /usr/$(get_libdir)/pkgconfig
	doins usr/$(get_libdir)/pkgconfig/*
}
