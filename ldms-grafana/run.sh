#!/bin/bash

D=$(realpath $(dirname $0))

. ${D}/../config.sh

# change working directory to the script's home
cd ${D}

NAME=grafana
IMG=ldms-grafana

OPTIONS=(
	-d --rm -p 3000:3000 --name ${NAME} --hostname ${NAME}
	--network ${NET}
	${IMG}
	)

docker run "${OPTIONS[@]}"
