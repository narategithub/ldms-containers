#!/bin/bash

NAME=grafana
IMG=grafana/grafana-oss:7.5.10-ubuntu

docker 	run -it --rm -p 3000:3000 --name ${NAME} --hostname ${NAME} \
	-v /home/narate/projects/dsosds:/var/lib/grafana/plugins/dsosds \
	${IMG}
