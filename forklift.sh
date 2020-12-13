#!/bin/bash -x
set -e

if [ -z "$1" ]
  then
    echo "No driver name supplied"
    exit -1
fi

# Prepare Environment
export FORKLIFT_DRIVER_NAME=${1}
export FORKLIFT_INSTALL_DIR=${FORKLIFT_INSTALL_DIR:-/opt/drivers}
export FORKLIFT_CACHE_DIR="${FORKLIFT_INSTALL_DIR}/archive/${FORKLIFT_DRIVER_NAME}"

# Prepare Filesystem
mkdir -p "$FORKLIFT_INSTALL_DIR"
mkdir -p "$FORKLIFT_CACHE_DIR"
rm -rf "${FORKLIFT_INSTALL_DIR:?}/${FORKLIFT_DRIVER_NAME}"

# Extract Drivers From Docker Image
if [ -d "${FORKLIFT_CACHE_DIR}/${FLATCAR_RELEASE_VERSION}" ]
then
    echo "Drivers for ${FORKLIFT_DRIVER_NAME}@${FLATCAR_RELEASE_VERSION} already exist locally"
else
    docker pull mediadepot/flatcar-${FORKLIFT_DRIVER_NAME}-driver:flatcar_${FLATCAR_RELEASE_VERSION}-${FORKLIFT_DRIVER_NAME}_latest
    docker run --rm -v ${FORKLIFT_CACHE_DIR}/${FLATCAR_RELEASE_VERSION}:/out mediadepot/flatcar-${FORKLIFT_DRIVER_NAME}-driver:flatcar_${FLATCAR_RELEASE_VERSION}-${FORKLIFT_DRIVER_NAME}_latest
fi

# setup symlink from cache directory to "install" directory
ln -s "${FORKLIFT_CACHE_DIR}/${FLATCAR_RELEASE_VERSION}" "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}"

if [ -d "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}/lib" ] ; then
    mkdir -p "${FORKLIFT_LD_ROOT}/etc/ld.so.conf.d"
    echo "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}/lib" > "${FORKLIFT_LD_ROOT}/etc/ld.so.conf.d/${FORKLIFT_DRIVER_NAME}.conf"
    ldconfig -r "${FORKLIFT_LD_ROOT}" 2> /dev/null
fi

# shellcheck disable=SC1090
source "${FORKLIFT_INSTALL_DIR}/${FORKLIFT_DRIVER_NAME}/install.sh"

