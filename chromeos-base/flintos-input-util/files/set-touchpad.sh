#!/bin/bash
# vim: noexpandtab:ts=4:sw=4

set_psmouse() {
	local proto=$1
	local conf=/etc/modprobe.d/flintos-psmouse.conf

	echo "options psmouse proto=${proto}" > ${conf}
	modprobe -r psmouse
	modprobe psmouse
}

help() {
	cat <<-EOF
	Usage: $0 bare | imps | exps | auto

	Switch between different modes of PS/2 protocol based touchpad.
	If your touchpad does not work, try switch to "bare" mode by running "$0 bare".
	EOF
	exit
}

# Check whether the script is run by root
if [ $(id -u) -ne 0 ]; then
	echo "You must be root to run this script."
	exit 1
fi

case "$1" in
	bare | imps | exps | auto)
		mount -o remount,rw /
		set_psmouse $1
		mount -o remount,ro /
		;;
	*)
	    help
		;;
esac
