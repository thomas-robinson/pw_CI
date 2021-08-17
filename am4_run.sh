#!/bin/bash -x

sudo yum install -y singularity
cd /lustre/AM4_run

export KMP_STACKSIZE=512m
export NC_BLKSZ=1M
export F_UFMTENDIAN=big
ulimit -s unlimited

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lustre/am4_build/AM4/exec/fms/build/libFMS/.libs
export LIBRARY_PATH=${LIBRARY_PATH}:/lustre/am4_build/AM4/exec/fms/build/libFMS/.libs
/lustre/am4_build/AM4/exec/am4_xanadu_2021.03.x
