#!/bin/bash -x


sudo yum install -y singularity
cd /lustre/build_2021.2
make -j 2 check
