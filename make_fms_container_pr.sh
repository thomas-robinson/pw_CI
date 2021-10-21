#!/bin/bash -x

cd ${1}
make check |& tee log.compile
