#!/bin/bash
# Need the scripts here (cannot be a soft link) for docker build context
cp -r ../scripts ./
docker build -t ldms-agg .
