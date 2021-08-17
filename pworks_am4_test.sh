#!/bin/bash -x

## Compile AM4
 cd /lustre

 rm -rf /lustre/am4*
 module load intel impi netcdf hdf5

 /contrib/pworks_am4_build.sh main
## Set up run directory
cd /lustre
tar -zxvf /contrib/AM4_run.tar.gz
cd AM4_run
cp /contrib/AM4_input_files/input.nml .
cp /contrib/AM4_input_files/diag_table .
## Run AM4
 /contrib/pworks_am4_run.sh


#i=0
#while [ $i -ne 1 ]
#do
#  sleep 30
#  i=`squeue | wc -l`
#done
#
#sleep 30
#i=0
#
#while [ $i -ne 1 ]
#do
#  sleep 30
#  i=`squeue | wc -l`
#done
#
#sleep 300
#cat /lustre/am4_build/AM4/exec/compile.log 
#cat /lustre/AM4_run/fms.out
