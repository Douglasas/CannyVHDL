#!/bin/bash

export QUARTUS_ROOTDIR=/opt/intelFPGA_lite/13.1/quartus

export PATH=${PATH}:${QUARTUS_ROOTDIR}/sopc_builder/bin

export SOCEDS_DEST_ROOT=/opt/intelFPGA_lite/16.0/embedded
               
source ${SOCEDS_DEST_ROOT}/env.sh
