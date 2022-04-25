#!/bin/bash

set -e

LOG() {
	echo $(date +"%F %T") "$@"
}

process_args() {
	DSOSD_LIST=( )
	while (( $# )); do
		case "$1" in
		--dsosd)
			shift
			eval "DSOSD_LIST+=( $1 )"
			;;
		--dsosd=*)
			eval "DSOSD_LIST+=( ${1#--dsosd=} )"
			;;
		esac
		shift
	done
}

{
process_args "$@"

LOG "DSOS_LIST: " "${DSOSD_LIST[@]}"

CONF=/opt/ovis/etc/dsosd.conf
LOG "Generating ${CONF}"
cat > ${CONF} <<EOF
$(
for E in "${DSOSD_LIST[@]}"; do
	echo $E
done
)
EOF

} 2>&1 | tee /var/log/start-ui.log

tail -f /dev/null
