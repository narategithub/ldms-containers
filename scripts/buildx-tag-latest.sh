#!/bin/bash

if [[ -t 1 ]]; then
	# Enable color for terminal
	RST='\e[0m'
	RED='\e[31m'
	YLW='\e[33m'
fi

USAGE=$( cat <<EOF
$(basename $0) -t SRC_TAG  IMG_0 [IMG_1 ...]

Options:
    -t SRC_TAG
	The SRC_TAG (the label after ':')  that 'latest' will point to.


Descriptions:
    The script uses 'docker buildx imagetools create' to modify 'IMG_X:latest'
    to point to IMG_X:SRC_TAG for all given IMG_X.

EOF
)

set -e

# Simple logging functions
_LOG() {
	local _TS=$(date -Iseconds)
	echo -e $(date -Iseconds) "$@"
}

_INFO() {
	_LOG "${YLW}INFO:${RST}" "$@"
}

_ERROR() {
	_LOG "${RED}ERROR:${RST}" "$@"
}

_ERROR_EXIT() {
	_ERROR "$@"
	exit -1
}

opt2var() {
	local V=$1
	V=${V#--}
	V=${V//-/_}
	V=${V^^}
	echo $V
}

handle_opt() {
	local NAME=$1
	local L=$(opt2var $1)
	local R=$2
	[[ -n "$R" ]] || _ERROR_EXIT "$NAME requires an argument"
	eval ${L}=${R}
}

# convert --arg=value to --arg "value"
ARGS=( )
for X in "$@"; do
	if [[ "$X" == --*=* ]]; then
		ARGS+=( "${X%%=*}" "${X#*=}" )
	else
		ARGS+=( "$X" )
	fi
done
set -- "${ARGS[@]}"

SRC_TAG=
TARGETS=()

while (($#)); do
	case "$1" in
	-t)
		SRC_TAG=$2
		shift
		;;
	--debug)
		DEBUG=1
		;;
	-h|-?|--help)
		cat <<<"$USAGE"
		exit 0
		;;
	-*)
		_ERROR_EXIT "Unknown option: $1"
		;;
	*)
		TARGETS+=( $1 )
		;;
	esac
	shift
done

[[ -n "${SRC_TAG}" ]] || _ERROR_EXIT "-t <SRC_TAG> option is required."
(( ${#TARGETS[*]} > 0 )) || {
	TARGETS=(
		ovishpc/ldms-dev
		ovishpc/ldms-dev-alma-8
		ovishpc/ldms-dev-alma-9
		ovishpc/ldms-dev-ubuntu-2204
		ovishpc/ldms-dev-ubuntu-2404
		ovishpc/ldms-dev-opensuse-15

		ovishpc/ldms-build
		ovishpc/ldms-samp
		ovishpc/ldms-agg
		ovishpc/ldms-maestro

		ovishpc/ldms-web-svc
		ovishpc/ldms-grafana
	)
}

for T in "${TARGETS[@]}" ; do
	_INFO "Tagging 'latest' with ${SRC_TAG} on ${T}"
	docker buildx imagetools create -t ${T}:latest ${T}:${SRC_TAG}
done
