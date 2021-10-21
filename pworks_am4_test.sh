#!/bin/bash -x

timestamp=`date +%s`
runDirRoot=/contrib/am4_build/${timestamp}

## Compile AM4
 mkdir -p $runDirRoot
 cd $runDirRoot

 /contrib/pworks_am4_build.sh main ${timestamp}
 export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${runDirRoot}/AM4/exec/fms/build/libFMS/.libs
 export LIBRARY_PATH=${LIBRARY_PATH}:${runDirRoot}/AM4/exec/fms/build/libFMS/.libs
 executable=${runDirRoot}/AM4/exec/am4_xanadu_2021.03.x
## Set up run directory
cd /contrib
mkdir -p $runDirRoot/runDir/INPUT
mkdir -p $runDirRoot/runDir/RESTART

cd $runDirRoot/runDir/INPUT
ln -sf /contrib/AM4_run/INPUT/* .
cd $runDirRoot/runDir
cp /contrib/AM4_run/* $runDirRoot/runDir 
cp /contrib/AM4_input_files/input.nml $runDirRoot/runDir
cp /contrib/AM4_input_files/diag_table $runDirRoot/runDir
cp ${executable} $runDirRoot/runDir

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
