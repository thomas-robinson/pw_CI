#!/bin/bash -x

cd ${1}
set -o pipefail
make check |& tee log.compile
