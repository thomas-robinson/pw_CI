#!/bin/bash -x

## Compile AM4
i=0
while [ $i -ne 1 ]
do
  sleep 30
  i=`squeue | wc -l`
done

sleep 30
i=0

while [ $i -ne 1 ]
do
  sleep 30
  i=`squeue | wc -l`
done

