#!/bin/bash

D=$(dirname $0)
cd ${D}

# Need the scripts here (cannot be a soft link) for docker build context
cp -r ../scripts ./
docker build -t ovishpc/ldms-agg .
