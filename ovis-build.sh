#!/bin/bash

LIST=( ldms-samp ldms-agg )

for D in "${LIST[@]}"; do
	pushd $D
	./ovis-build.sh
	popd
done
