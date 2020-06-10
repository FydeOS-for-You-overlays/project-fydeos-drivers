# Copyright (c) 2010 The Chromium OS Authors.  All rights reserved.
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

EGIT_REPO_URI="git@gitlab.fydeos.xyz:misc/tpm-emulator.git"
EGIT_BRANCH="github_master"
#EGIT_COMMIT="268acb688c41643175bc244decd5bb6fa288c38f"

inherit cmake-utils git-2 toolchain-funcs fydeos-kernel-module

DESCRIPTION="TPM Emulator with small google-local changes"
LICENSE="GPL-2"
HOMEPAGE="https://developer.berlios.de/projects/tpm-emulator"
SLOT="0"
IUSE="doc"
KEYWORDS="*"

DEPEND="app-crypt/trousers
	dev-libs/gmp"

RDEPEND="
	${DEPEND}
"

src_configure() {
	tc-export CC CXX LD AR RANLIB NM
	CHROMEOS=1 cmake-utils_src_configure
}

src_compile() {
	# KV_OUT_DIR is declared by not exported by portage, export it so it will be visible in below make stage
	unset ARCH

	# This kernel header file is required to build the kernel module but not included in the source, copy it
	# from the kernel source tree we build against.
	cp ${KERNEL_DIR}/drivers/char/tpm/tpm.h ${S}/tpmd_dev/linux/tpm.h
  cp ${KERNEL_DIR}/drivers/char/tpm/tpm_tis_core.h ${S}/tpmd_dev/linux/tpm_tis_core.h
  einfo KERNEL_RELEASE: ${KERNEL_RELEASE} KV_OUT_DIR: ${KV_OUT_DIR}
	cmake-utils_src_compile
	# This would be normally done in kernel module build, but we have
	# copied the kernel module to the kernel tree.
	TPMD_DEV_SRC_DIR="${S}/tpmd_dev/linux"
	TPMD_DEV_BUILD_DIR="${CMAKE_BUILD_DIR}/tpmd_dev/linux"
	mkdir -p "${TPMD_DEV_BUILD_DIR}"
	sed -e "s/\$TPM_GROUP/tss/g" \
		< "${TPMD_DEV_SRC_DIR}/tpmd_dev.rules.in" \
		> "${TPMD_DEV_BUILD_DIR}/tpmd_dev.rules"
}

src_install() {
	# Install kernel module tpmd_dev
	MODULE_NAMES="tpmd_dev(kernel/drivers/char/tpm:${BUILD_DIR}/tpmd_dev/linux)"
	linux-mod_src_install

	# TODO(semenzato): need these for emerge on host, to run tpm_lite tests.
	# insinto /usr/lib
	# doins "${CMAKE_BUILD_DIR}/tpm/libtpm.a"
	# doins "${CMAKE_BUILD_DIR}/crypto/libcrypto.a"
	# doins "${CMAKE_BUILD_DIR}/tpmd/unix/libtpmemu.a"
	# insinto /usr/include
	# doins "${S}/tpmd/unix/tpmemu.h"
	exeinto /usr/sbin
	doexe "${CMAKE_BUILD_DIR}/tpmd/unix/tpmd"

	# Don't install udev rule per Simon's request
	#insinto /etc/udev/rules.d
	#TPMD_DEV_BUILD_DIR="${CMAKE_BUILD_DIR}/tpmd_dev/linux"
	#RULES_FILE="${TPMD_DEV_BUILD_DIR}/tpmd_dev.rules"
	#newins "${RULES_FILE}" 80-tpmd_dev.rules

	insinto /etc/init
	doins etc/init/tpm-emulator.conf
	doins etc/init/tpm-probe.override
  doins ${FILESDIR}/tcsd.override
  insinto /usr/share/cros/init
  doins ${FILESDIR}/tcsd-pre-start-tpm.sh
}
