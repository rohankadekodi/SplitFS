#!/bin/bash

set -x

current_dir=`readlink -f ./`
boost_ycsb=`readlink -f ../../boost-ycsb`

cd $boost_ycsb
make clean
make -j
cd $current_dir

