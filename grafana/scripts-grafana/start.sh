#!/bin/bash

LOG() {
	echo $(date +"%F %T") "$@"
}

# invoke grafana run script
/run.sh >/var/log/grafana/run.log 2>&1 &

{
while true; do
	sleep 1
	S=$( curl -S -L http://localhost:3000/api/datasources --user admin:admin )
	(( $? == 0 )) || continue # not ready

	# Seems to be ready
	LOG "Grafana seems to be ready, available datasources: ${S}"
	LOG "Adding LDMS datasource"
	curl -S -X "POST" http://localhost:3000/api/datasources \
	     -H "Content-Type: application/json" \
	     --user admin:admin --data-binary @/docker/datasources.json
	S=$( curl -S -L http://localhost:3000/api/datasources --user admin:admin )
	LOG "current datasources: ${S}"
	break
done
LOG "/docker/start.sh DONE -- pending"
} > /var/log/grafana/start.log 2>&1

# This script is the `init` process in the container
tail -f /dev/null
