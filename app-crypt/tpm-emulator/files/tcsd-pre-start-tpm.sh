# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

JOB="tcsd-pre-start"

# Check the vboot nvram bit which indicates that the TPM was reset in the
# middle of a command within 30s of boot in the previous boot session,
# and report if bit is ON.
if crossystem "tpm_attack?1"; then
  metrics_client -v TPM.EarlyResetDuringCommand || \
      logger -t "${JOB}" "metrics_client (early reset): status $?"
  crossystem "tpm_attack=0" || \
      logger -t "${JOB}" "crossystem: status $?"
fi

if [ -e /sys/class/misc/tpm0 ]; then
  TPMDIR=/sys/class/misc/tpm0/device
else
  TPMDIR=/sys/class/tpm/tpm0/device
fi
if [ -e "$TPMDIR/owned" ]; then
  owned=$(cat "$TPMDIR/owned" || echo "")
  if [ "$owned" -eq "0" ]; then
    # Clean up any existing tcsd state.
    rm -rf /var/lib/tpm/*
  elif [ "$owned" -eq "1" ]; then
    # Already owned.
    # Check if trousers' system.data is size zero.  If so, then the TPM has
    # been owned already and we need to copy over an empty system.data to be
    # able to use it in trousers.
    if [ ! -f /var/lib/tpm/system.data ] ||
       [ ! -s /var/lib/tpm/system.data ]; then
      if [ ! -e /var/lib/tpm ]; then
        mkdir -m 0700 -p /var/lib/tpm
      fi
      umask 0177
      cp --no-preserve=mode /etc/trousers/system.data.auth \
        /var/lib/tpm/system.data
    fi
  fi
fi

# Check the dictionary-attack counter.
if grep -q "Manufacturer: 0x49465800" "$TPMDIR/caps"; then
  # Infineon has a vendor-specific capability for this. The following command
  # queries the TPM_CAP_MFR capability area.
  tpm_command="00 c1 00 00 00 16 00 00 00 65 00 00 00 10 00 00 00 04 00 00 \
               08 02"
  # The output is vendor-specific; we're interested in the 24th byte. The
  # output is printed in rows of 8 bytes so we want row 3, field 8.
  count=$(($(tpmc raw $tpm_command | awk 'NR == 3 { print $8; }')))
elif [ -e "$TPMDIR/caps" ]; then
  # If not Infineon, try to query the TPM_CAP_DA_LOGIC capability area with a
  # TPM_ET_SRK entity type.
  #tpm_command="00 c1 00 00 00 14 00 00 00 65 00 00 00 19 00 00 00 02 00 04"
  # The output is a TPM_DA_INFO structure; we're interested in the least
  # significant byte of the currentCount field (row 3, field 3).
  #count=$(($(tpmc raw $tpm_command | awk 'NR == 3 { print $3; }')))
  count=100
fi
if [ -z "$count" ]; then
  # Report 100 when we don't know the counter value.
  count=100
fi
metrics_client -e Platform.TPM.DictionaryAttackCounter $count 100 ||
    logger -t "${JOB}" "metrics_client -e: status $?"
if [ $count -ne 0 ]; then
  logger -t "${JOB}" "WARNING: Non-zero dictionary attack counter found: $count"
  metrics_client -v TPM.NonZeroDictionaryAttackCounter ||
      logger -t "${JOB}" "metrics_client -v: status $?"
fi
