#!/bin/bash -x

cd ${1}
make -j 2 check |& tee log.compile
