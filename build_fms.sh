#!/bin/sh -x
buildRoot=/contrib/intel_2018_fms
## figure out directories and what you are cloning
if [ -z "$1" ]
  then
    echo "No branch supplied; using main"
    buildDir=${buildRoot}/main_`date +%s`
  else
    echo Setting up directory ${buildRoot}/${1}
    buildDir=${buildRoot}/${1}
fi
rm -rf ${buildDir}
logdir=${buildDir}/log
mkdir -p ${buildDir}/build
mkdir -p ${logdir}
cd ${buildDir}
## Clone FMS
if [ -z "$1" ]
  then
    echo "Cloning main branch"
    git clone https://github.com/NOAA-GFDL/FMS.git |& tee ${logdir}/clone.log
  else
    echo Merge in PR
   git clone https://github.com/NOAA-GFDL/FMS.git |& tee ${logdir}/clone.log
   # Merge the PR
   cd FMS && git fetch origin ${1} && git merge FETCH_HEAD |& tee ${logdir}/fetch.log
 
fi
## Set up the build environment
set echo off
module load intel/18.0.5.274 impi/2018.4.274 netcdf/4.6.1 && export INTEL_LICENSE_FILE=27009@noaa-license.parallel.works
set echo on

export CC=`which mpiicc`
export FC=`which mpiifort`
export CPPFLAGS="`nc-config --cflags` `nc-config --fflags`"
export LIBS="`nc-config --libs` `nc-config --flibs`"
export LDFLAGS="`nc-config --libs` `nc-config --flibs`"
export MPI_LAUNCHER="`which srun` --mpi=pmi2"

## Build FMS
mkdir -p ${buildDir}/build && cd ${buildDir}/build
autoreconf -i ${buildDir}/FMS/configure.ac |& tee ${logdir}/autoreconf.log 
${buildDir}/FMS/configure |& tee ${logdir}/configure.out 
## copy the config.log to the logdir
cp config.log ${logdir}/config.log
## Run make
make |& tee ${logdir}/compile.log
