#!/bin/bash

D=$(realpath $(dirname $0))

for S in samp-{01..8}; do
	./ldms-samp/run.sh --name ${S}
done

./ldms-agg/run.sh --name agg-11 --prdcr "samp-{01,02}"
./ldms-agg/run.sh --name agg-12 --prdcr "samp-{03,04}"
./ldms-agg/run.sh --name agg-13 --prdcr "samp-{05,06}"
./ldms-agg/run.sh --name agg-14 --prdcr "samp-{07,08}"

./ldms-agg/run.sh --name agg-21 --prdcr "agg-{11,12}" --strgp "meminfo loadavg"
./ldms-agg/run.sh --name agg-22 --prdcr "agg-{13,14}" --strgp "meminfo loadavg"

./ldms-agg/run.sh --name csv-21 --prdcr "agg-{11,12}" \
		  --strgp-conf ${D}/csv/csv.conf \
		  --interval 60000000 --offset 400000 \
		  -v "${D}/scripts/ldmsd-conf:/opt/ovis/sbin/ldmsd-conf" \
		  -v "${D}:/opt/ovis/etc/ldms/function_csv.conf" \
		  -v "${D}/csv_store/csv-21:/store"
./ldms-agg/run.sh --name csv-22 --prdcr "agg-{13,14}" \
		  --strgp-conf ${D}/csv/csv.conf \
		  --interval 60000000 --offset 400000 \
		  -v "${D}/scripts/ldmsd-conf:/opt/ovis/sbin/ldmsd-conf" \
		  -v "${D}:/opt/ovis/etc/ldms/function_csv.conf" \
		  -v "${D}/csv_store/csv-22:/store"

./ldms-ui/run.sh --name ui --dsosd "agg-{21,22}"

./ldms-grafana/run.sh
