#!/bin/bash

set -e

LOG() {
	echo $(date +"%F %T") "$@"
}

process_args() {
	# This function reset and build STRGP_LIST and STORE_PATH variables
	STRGP_LIST=( )
	STORE_PATH="/store"
	while (( $# )); do
		case "$1" in
		--strgp)
			shift
			eval "STRGP_LIST+=( $1 )"
			;;
		--strgp=*)
			eval "STRGP_LIST+=( ${1#--strgp=} )"
			;;
		--store-path)
			shift
			STORE_PATH="$1"
			;;
		--store-path=*)
			STORE_PATH="${1#--store-path=}"
			;;
		esac
		shift
	done
}

{
. /opt/ovis/etc/profile.d/set-ovis-variables.sh

/sbin/sshd

CONF="/opt/ovis/etc/ldms.conf"
if [[ -e "${CONF}" ]]; then
	LOG "Use existing ${CONF}"
else
	LOG "Generating ${CONF}f"
	# parameters from the 'docker run' will be passed to ldmsd-conf to
	# generate the ldms.conf config file
	ldmsd-conf "$@" > ${CONF}
fi

process_args "$@"
if (( ${#STRGP_LIST[@]} )); then
	# dsosd
	cat > /opt/ovis/etc/dsosd.json <<-EOF
	{
	  "${HOSTNAME}":{
	$(
	    local S
	    local C=" "
	    for S in "${STRGP_LIST[@]}"; do
		echo "   ${C}\"$S\":\"${STORE_PATH}/$S\""
		C=","
	    done
	)
	  }
	}
	EOF
	LOG "Starting dsosd"
	dsosd-start
fi

LOG "Starting ldmsd"
ldmsd-start

LOG "start routine done, pending init process ..."
} | tee /var/log/start.log

# This script is the `init` process in the container
tail -f /dev/null
