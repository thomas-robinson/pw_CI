#!/bin/bash -x
#SBATCH --job-name=test_am4
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=03:45:00               # Time limit hrs:min:sec
#SBATCH --output=/lustre/run_am4_%j.log   # Standard output and error log
set -o pipefail

#cd /lustre/AM4_run
 module load intel impi netcdf hdf5


export KMP_STACKSIZE=512m
export NC_BLKSZ=1M
export F_UFMTENDIAN=big
ulimit -s unlimited

srun --mpi=pmi2 -n 24 -c 1 ./am4_xanadu_2021.03.x |& tee fms.out
