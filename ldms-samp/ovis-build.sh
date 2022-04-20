#!/bin/bash
#
# build ovis binaries for `sampler` containers using `ovishpc/ovis-centos-build`
# docker image.

set -e

D=$(dirname $0)
IMG=ovishpc/ovis-centos-build
OVIS_REV=${OVIS_REV:-OVIS-4}
ODIR=${D}/ovis

if [[ -d ${ODIR} ]]; then
	mv ${ODIR} ${ODIR}.$(date +%s)
fi
mkdir -p ${ODIR}

CFLAGS=( -O2 )

OPTIONS=(
	--prefix=/opt/ovis
	--enable-python
	--enable-etc
	--enable-munge

	# samplers for testing
	--enable-zaptest
        --enable-ldms-test
        --enable-test_sampler
        --enable-list_sampler
        --enable-record_sampler
        --enable-tutorial-sampler
        --enable-tutorial-store
)

{ cat <<EOF
set -e
set -x
cd ~
mkdir ovis
pushd ovis
git init .
git remote add github https://github.com/ovis-hpc/ovis
git fetch github ${OVIS_REV}
git checkout FETCH_HEAD
./autogen.sh
mkdir build
pushd build
../configure ${OPTIONS[@]} CFLAGS="${CFLAGS[*]}"
make
make install
chown ${UID}:${UID} -R /opt/ovis
EOF
} | docker run -i --rm --name ldms-samp-build --hostname ldms-samp-build \
	-v $(realpath ${ODIR}):/opt/ovis \
	${IMG} "/bin/bash"
