#!/bin/bash -xe
#SBATCH --job-name=test_am4
#SBATCH --nodes=1
##SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --time=03:45:00               # Time limit hrs:min:sec
#SBATCH --output=/lustre/test_am4_%j.log   # Standard output and error log

set -o pipefail

## variables
refDir=/contrib/reference_AM4/2021.2_c/2021.03/intel_2021.2_container
#workDir=/lustre/AM4_run
workDir=/contrib/am4_build/intel2021/main
rm -rf ${workDir}
mkdir -p ${workDir}
## Install singularity
sudo yum install -y singularity
## Compile AM4


#srun --mpi=pmi2 -n 24 singularity exec -B /lustre,/contrib /contrib/intel2021.2_netcdfc4.7.4_ubuntu.sif /contrib/am4_build.sh main
#singularity exec -B /lustre,/contrib /contrib/intel2021.2_netcdfc4.7.4_ubuntu.sif /contrib/am4_build.sh main
## Set up the run directory
cd ${workDir}
mkdir -p runDir/INPUT
mkdir -p runDir/RESTART
cd ${workDir}/runDir
#cp /contrib/AM4_run/* .
find /contrib/AM4_run/ -maxdepth 1 -type f -exec cp -t . {} +
cd INPUT
ln -sf /contrib/AM4_run/INPUT/* .
cd ${workDir}/runDir
cp /contrib/AM4_input_files/input.nml .
cp /contrib/AM4_input_files/diag_table .
## Build the executable
singularity exec -B /lustre,/contrib /contrib/intel2021.2_netcdfc4.7.4_ubuntu.sif /contrib/am4_build.sh main

## Run the model
srun --mpi=pmi2 -n 24 -c 1 sudo yum install -y singularity
srun --mpi=pmi2 -n 24 -c 1 sudo yum install -y singularity
srun --mpi=pmi2 -n 24 -c 1 singularity exec -B /lustre,/contrib,${workdir} /contrib/intel2021.2_netcdfc4.7.4_ubuntu.sif /contrib/am4_run.sh |& tee fms.out

/contrib/am4_compare.sh $refDir/RESTART $workDir/runDir/RESTART
#rm -rf ${workDir}
