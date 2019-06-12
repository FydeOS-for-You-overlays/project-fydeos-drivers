# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 autotools

DESCRIPTION="Libtpms-based TPM emulator with socket, character device, and Linux CUSE interface."
HOMEPAGE="https://github.com/stefanberger/swtpm"
SRC_URI=""
EGIT_REPO_URI="git@gitlab.fydeos.xyz:misc/swtpm_bin.git"
EGIT_BRANCH="master"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
  insinto /usr/lib64
  doins lib64/*
  dosym libswtpm_libtpms.so.0.0.0 /usr/lib64/libswtpm_libtpms.so.0
  dosym libtpms.so.0.6.0 /usr/lib64/libtpms.so.0
  dosym libtpm_unseal.so.1.0.0 /usr/lib64/libtpm_unseal.so.1
  exeinto /usr/sbin
  doexe sbin/*
  insinto /etc/init
  doins init/swtpm.conf
}

