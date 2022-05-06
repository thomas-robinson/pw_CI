#!/bin/bash -x


if [ -z "$1" ]
  then
    echo "No branch supplied; using main"
    branch=main
  else
    echo Branch is ${1}
    branch=${1}
fi

sudo yum install -y singularity
cd /contrib/AM4_run/intel2021/main/runDir

export KMP_STACKSIZE=512m
export NC_BLKSZ=1M
export F_UFMTENDIAN=big
ulimit -s unlimited

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/contrib/am4_build/intel2021/main/AM4/exec/fms/build/libFMS/.libs
export LIBRARY_PATH=${LIBRARY_PATH}:/contrib/am4_build/intel2021/main/AM4/exec/fms/build/libFMS/.libs
/contrib/am4_build/intel2021/${branch}/AM4/exec/am4_xanadu_2021.03.x

