#!/bin/sh -x
#SBATCH --job-name=FMS_container
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --time=00:15:00               # Time limit hrs:min:sec
#SBATCH --output=FMS_container_%j.log   # Standard output and error log

buildDir=/lustre/build_2021.2/${1}
logdir=/contrib/${1}
# create directories
mkdir -p ${buildDir}
mkdir -p ${logdir}

#Install singularity
sudo yum install -y singularity

#clone FMS
cd /lustre
git clone https://github.com/NOAA-GFDL/FMS.git |& tee ${logdir}/clone.log
# Check out the PR
cd FMS && git fetch origin ${1} && git merge FETCH_HEAD |& tee ${logdir}/fetch.log


# Set up build
mkdir -p ${buildDir} && cd ${buildDir}
autoreconf -i ../FMS/configure.ac |& tee ${logdir}/autoreconf.log

#Build FMS
singularity exec -B /lustre,/contrib /contrib/intel2021.2_netcdfc4.7.4_ubuntu.sif autoreconf -i /lustre/FMS/configure.ac |& tee ${logdir}/contreconf.log
singularity exec -B /lustre,/contrib /contrib/intel2021.2_netcdfc4.7.4_ubuntu.sif /lustre/FMS/configure --prefix=${buildDir} FC=mpiifort CC="mpiicc -no-multibyte-chars" CPPFLAGS="-L/opt/netcdf-fortran/lib -lnetcdff -I/opt/netcdf-fortran/include -I/opt/netcdf-fortran/include -I/opt/netcdf-c/include -I/opt/hdf5/include -I/include -L/opt/netcdf-c/lib -lnetcdf" LIBS="-L/opt/netcdf-fortran/lib -lnetcdff -L/opt/netcdf-c/lib -lnetcdf" |& tee ${logdir}/configrun.log
cp config.log ${logdir}/config.log 

singularity exec -B /lustre,/contrib /contrib/intel2021.2_netcdfc4.7.4_ubuntu.sif /contrib/make_fms_container_pr.sh ${buildDir} |& tee ${logdir}/make_fms_container.log
