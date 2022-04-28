#!/bin/bash

D=$(dirname $0)
cd ${D}

docker build -t ovishpc/ldms-ui .
