#!/bin/sh -x

buildDir=/shared/build_2018/${1}
logdir=/contrib/2018/${1}

mkdir -p ${buildDir}
mkdir -p ${logdir}

if [ -z "$1" ]
  then
    echo "No branch supplied; using main"
    branch=main
  else
    echo Branch is ${1}
    branch=${1}
fi
#clone FMS
cd ${buildDir}
###### Move if statement here
git clone -b ${branch} https://github.com/NOAA-GFDL/FMS.git |& tee ${logdir}/clone.log

# Set up build
mkdir build && cd build
autoreconf -i ../FMS/configure.ac ## tee this to a log
module load intel/18.0.5.274 impi/2018.4.274 netcdf/4.6.1 && export INTEL_LICENSE_FILE=27009@noaa-license.parallel.works

export CC=`which mpiicc`
export FC=`which mpiifort`
export CPPFLAGS="`nc-config --cflags` `nc-config --fflags`"
export LIBS="`nc-config --libs` `nc-config --flibs`"
export LDFLAGS="`nc-config --libs` `nc-config --flibs`"
export MPI_LAUNCHER="`which srun` --mpi=pmi2"
../FMS/configure # tee this to a log
## copy the config.log to the logdir
make check |& tee ${logdir}/compile.log 
