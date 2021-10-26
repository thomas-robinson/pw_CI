#!/bin/bash -x
set -o pipefail

# sudo yum install -y singularity

if [ -z "$1" ]
  then
    echo "No branch supplied; using main"
    branch=main
  else
    echo Branch is ${1}
    branch=${1}
fi
 topDir=/contrib/am4_build/intel2021/${branch}

export LANG=en_US.utf8
export LC_ALL=en_US.utf8
 
 mkdir -p ${topDir} 
## Build the AM4 from github
 cd ${topDir}
 git clone --recursive https://github.com/NOAA-GFDL/AM4.git -b ${branch}
## Update source code to main branch
     cd ${topDir}/AM4/src/FMS
     git merge origin/main
## Compile AM4
     cd ${topDir}/AM4/exec
     make -j 20 HDF_INCLUDE=-I/opt/hdf5/include HDF_LIBS="-L/opt/hdf5/lib -lhdf5 -lhdf5_fortran -lhdf5_hl -lhdf5hl_fortran" SH=sh CC="`which mpiicc` -no-multibyte-chars" |& tee compile.log

