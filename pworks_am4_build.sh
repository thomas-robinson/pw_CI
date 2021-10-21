#!/bin/bash -x
#SBATCH --job-name=test_am4
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=03:45:00               # Time limit hrs:min:sec
#SBATCH --output=/lustre/build_am4_%j.log   # Standard output and error log

 module purge
 module load intel impi netcdf hdf5
 export INTEL_LICENSE_FILE=27009@noaa-license.parallel.works

export CC=`which mpiicc`
export FC=`which mpiifort`

 if [ -z "$1" ]
  then
    echo "No branch supplied; using main"
    branch=main
  else
    echo Branch is ${1}
    branch=${1}
 fi

 topDir=/contrib/am4_build/${2}
 mkdir -p ${topDir}

## Build the AM4 from github
 cd ${topDir}
 sleep 5
 git clone --recursive https://github.com/NOAA-GFDL/AM4.git -b ${branch}
## Update source code to main branch
     cd ${topDir}/AM4/src/FMS
     git merge origin/main
## Compile AM4
     cd ${topDir}/AM4/exec
     make -j 4 HDF_INCLUDE=-I/apps/hdf5/1.10.4/intel/16.1.150/include HDF_LIBS="-L/apps/hdf5/1.10.4/intel/16.1.150//lib -lhdf5 -lhdf5_fortran -lhdf5_hl -lhdf5hl_fortran" SH=sh CC="`which mpiicc` -no-multibyte-chars" |& tee compile.log
#  /contrib/pworks_am4_run.sh
