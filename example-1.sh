#!/bin/bash

for S in samp-{01..8}; do
	./ldms-samp/run.sh --name ${S}
done

./ldms-agg/run.sh --name agg-11 --prdcr "samp-{01,02}"
./ldms-agg/run.sh --name agg-12 --prdcr "samp-{03,04}"
./ldms-agg/run.sh --name agg-13 --prdcr "samp-{05,06}"
./ldms-agg/run.sh --name agg-14 --prdcr "samp-{07,08}"

./ldms-agg/run.sh --name agg-21 --prdcr "agg-{11,12}" --strgp "meminfo vmstat"
./ldms-agg/run.sh --name agg-22 --prdcr "agg-{13,14}" --strgp "meminfo vmstat"

./ldms-ui/run.sh --name ui --dsosd "agg-{21,22}"

./grafana/run.sh
