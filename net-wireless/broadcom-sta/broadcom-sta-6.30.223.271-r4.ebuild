# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils linux-info linux-mod toolchain-funcs

DESCRIPTION="Broadcom's IEEE 802.11a/b/g/n hybrid Linux device driver"
HOMEPAGE="https://www.broadcom.com/support/802.11"
SRC_BASE="https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/hybrid-v35"
SRC_URI="x86? ( ${SRC_BASE}-nodebug-pcoem-${PV//\./_}.tar.gz )
	amd64? ( ${SRC_BASE}_64-nodebug-pcoem-${PV//\./_}.tar.gz )
	https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/README_${PV}.txt -> README-${P}.txt"

LICENSE="Broadcom"
#KEYWORDS="-* ~amd64 ~x86"
KEYWORDS="-* amd64 x86"

RESTRICT="mirror"

IUSE_KERNEL_VERS=(
	kernel-3_8
	kernel-3_10
	kernel-3_14
	kernel-3_18
	kernel-4_4
	kernel-4_12
	kernel-4_14
  kernel-4_19
  kernel-5_4
)
IUSE="${IUSE_KERNEL_VERS[*]}"
REQUIRED_USE="?? ( ${IUSE_KERNEL_VERS[*]} )"

RDEPEND="virtual/linux-sources"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

MODULE_NAMES="wl(net/wireless)"
MODULESD_WL_ALIASES=("wlan0 wl")

pkg_setup() {
	# bug #300570
	# NOTE<lxnay>: module builds correctly anyway with b43 and SSB enabled
	# make checks non-fatal. The correct fix is blackisting ssb and, perhaps
	# b43 via udev rules. Moreover, previous fix broke binpkgs support.
	CONFIG_CHECK="~!B43 ~!BCMA ~!SSB ~!CC_IS_CLANG"
	CONFIG_CHECK2="LIB80211 ~!MAC80211 ~LIB80211_CRYPT_TKIP"
	ERROR_B43="B43: If you insist on building this, you must blacklist it!"
	ERROR_BCMA="BCMA: If you insist on building this, you must blacklist it!"
	ERROR_SSB="SSB: If you insist on building this, you must blacklist it!"
	ERROR_LIB80211="LIB80211: Please enable it. If you can't find it: enabling the driver for \"Intel PRO/Wireless 2100\" or \"Intel PRO/Wireless 2200BG\" (IPW2100 or IPW2200) should suffice."
	ERROR_MAC80211="MAC80211: If you insist on building this, you must blacklist it!"
	ERROR_PREEMPT_RCU="PREEMPT_RCU: Please do not set the Preemption Model to \"Preemptible Kernel\"; choose something else."
	ERROR_LIB80211_CRYPT_TKIP="LIB80211_CRYPT_TKIP: You will need this for WPA."
	if kernel_is ge 3 8 8; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211 ~!PREEMPT_RCU ~!PREEMPT"
	elif kernel_is ge 2 6 32; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211"
	elif kernel_is ge 2 6 31; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT ~!MAC80211"
	elif kernel_is ge 2 6 29; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT COMPAT_NET_DEV_OPS"
	else
		CONFIG_CHECK="${CONFIG_CHECK} IEEE80211 IEEE80211_CRYPT_TKIP"
	fi

	linux-mod_pkg_setup

	BUILD_PARAMS="-C ${KV_OUT_DIR} M=${S}"
	BUILD_TARGETS="wl.ko"
}

src_prepare() {
  einfo "kv_out_dir=" ${KV_OUT_DIR} " M=${S}"
	PATCHES_COMMON=(
		${FILESDIR}/${PN}-6.30.223.141-makefile.patch
		${FILESDIR}/${PN}-6.30.223.141-eth-to-wlan.patch
		${FILESDIR}/${PN}-6.30.223.141-gcc.patch
		${FILESDIR}/${PN}-6.30.223.248-r3-Wno-date-time.patch
		${FILESDIR}/${PN}-6.30.223.271-device-id-table.patch
	)

	PATCHES_3_18=(
		${FILESDIR}/${PN}-6.30.223.271-r1-linux-3.18.patch
	)

	PATCHES_4_4=(
		${FILESDIR}/${PN}-6.30.223.271-r2-linux-4.3-v2.patch
	)

	PATCHES_4_12=(
		${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.7.patch
		${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.8.patch
		${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.11.patch
		${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.12.patch
	)

	PATCHES_4_14=(
		${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.14.patch
	)

  PATCHES_4_19=(
    ${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.15.patch
  )

  PATCHES_5_4=(
    ${FILESDIR}/${PN}-6.30.223.271-r5-linux-5.1.patch
  )

	PATCHES=("${PATCHES_COMMON[@]}")
	if use kernel-3_18; then
		einfo "Applying patches for kernel 3.18"
		PATCHES=("${PATCHES[@]}" "${PATCHES_3_18[@]}")
  fi
	if use kernel-4_4; then
		einfo "Applying patches for kernel 4.4"
		PATCHES=("${PATCHES[@]}" "${PATCHES_3_18[@]}" "${PATCHES_4_4[@]}")
  fi
	if use kernel-4_12; then
		einfo "Applying patches for kernel 4.12"
		PATCHES=("${PATCHES[@]}" "${PATCHES_3_18[@]}" "${PATCHES_4_4[@]}" "${PATCHES_4_12[@]}")
  fi
	if use kernel-4_14; then
		einfo "Applying patches for kernel 4.14"
		PATCHES=("${PATCHES[@]}" "${PATCHES_3_18[@]}" "${PATCHES_4_4[@]}" "${PATCHES_4_12[@]}" "${PATCHES_4_14[@]}")
  fi
  if use kernel-4_19; then
    einfo "Applying patches for kernel 4.19"
    PATCHES=("${PATCHES[@]}" "${PATCHES_3_18[@]}" "${PATCHES_4_4[@]}" "${PATCHES_4_12[@]}" "${PATCHES_4_14[@]}" "${PATCHES_4_19[@]}")
  fi
  if use kernel-5_4; then
    einfo "Applying patches for kernel 5.4"
    PATCHES=("${PATCHES[@]}" "${PATCHES_3_18[@]}" "${PATCHES_4_4[@]}" "${PATCHES_4_12[@]}" "${PATCHES_4_14[@]}" "${PATCHES_4_19[@]}" "${PATCHES_5_4[@]}")
	fi

	epatch ${PATCHES[@]}

	eapply_user
}

src_install() {
	linux-mod_src_install
	rm -f ${ED}/etc/modprobe.d/wl.conf

	dodoc "${DISTDIR}/README-${P}.txt"
	dobin ${FILESDIR}/switch-brcm-driver

	insinto /etc/modprobe.d
	doins ${FILESDIR}/flintos-brcm.conf

	# Install this per license requirement
	insinto /usr/share/license
	newins ${S}/lib/LICENSE.txt ${PN}-license.txt
}
