#!/bin/bash
#
# NOTE: This script copies '../ldms-agg/ovis' (ldms+sos), then install 'numsos'
# on top of it.

LOG() {
	echo $(date +"%F %T") "$@"
}

set -e

D=$(dirname $0)
IMG=ovishpc/ovis-centos-build
NUMSOS_REV=${NUMSOS_REV:-dsos_support}
ODIR=${D}/ovis
AGG_OVIS_DIR="${D}/../ldms-agg/ovis"

[[ -d "${AGG_OVIS_DIR}" ]] || {
	LOG "'${AGG_OVIS_DIR}' not found, please build ovis for ldms-agg first"
	exit -1
}

if [[ -d ${ODIR} ]]; then
	mv ${ODIR} ${ODIR}.$(date +%s)
fi
cp -a "${AGG_OVIS_DIR}" "${ODIR}"

CFLAGS=( -O2 )

OPTIONS=(
	--prefix=/opt/ovis
	--with-sos=/opt/ovis
)

{ cat <<EOF
set -e
set -x

cd ~

. /opt/ovis/etc/profile.d/set-ovis-variables.sh

#### NUMSOS ####
mkdir numsos
pushd numsos
git init .
git remote add github https://github.com/nick-enoent/numsos
git fetch github ${NUMSOS_REV}
git checkout FETCH_HEAD
./autogen.sh
mkdir build
pushd build
../configure ${OPTIONS[@]} PYTHON=python3 CFLAGS="${CFLAGS[*]}"
make
make install
popd
popd

chown ${UID}:${UID} -R /opt/ovis
EOF
} | docker run -i --rm --name ldms-ui-build --hostname ldms-ui-build \
	-v $(realpath ${ODIR}):/opt/ovis \
	${IMG} "/bin/bash"
