#!/bin/sh -x



build_folder=build_`date +%s`
echo $build_folder

if [ -z "$1" ]
  then
    echo "No branch supplied; using main"
    branch=main
  else
    echo Branch is ${1}
    branch=${1}
fi
#clone FMS
mkdir -p /shared/$build_folder
cd /shared/$build_folder
#mkdir -p /home/Thomas.Robinson/$build_folder
#cd /home/Thomas.Robinson/$build_folder

git clone -b ${branch} https://github.com/NOAA-GFDL/FMS.git

# Set up build
mkdir build && cd build
autoreconf -i ../FMS/configure.ac
module load intel/18.0.5.274 impi/2018.4.274 netcdf/4.6.1 && export INTEL_LICENSE_FILE=27009@noaa-license.parallel.works

export CC=`which mpiicc`
export FC=`which mpiifort`
export CPPFLAGS="`nc-config --cflags` `nc-config --fflags`"
export LIBS="`nc-config --libs` `nc-config --flibs`"
export LDFLAGS="`nc-config --libs` `nc-config --flibs`"
export MPI_LAUNCHER="`which srun` --mpi=pmi2"
../FMS/configure
make check |& tee compile.log
