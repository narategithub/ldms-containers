#!/bin/bash

D=$(realpath $(dirname $0))

. ${D}/../config.sh

# change working directory to the script's home
cd ${D}

NAME=grafana
#IMG=grafana/grafana-oss:8.0.2-ubuntu
#IMG=grafana/grafana-oss:7.5.10-ubuntu
IMG=ldms-grafana

OPTIONS=(
	-it --rm -p 3000:3000 --name ${NAME} --hostname ${NAME}
	#-v ${D}/dsosds:/var/lib/grafana/plugins/dsosds
	#-v ${D}/grafana.ini:/etc/grafana/grafana.ini
	--network ${NET}
	${IMG}
	)

docker run "${OPTIONS[@]}"
