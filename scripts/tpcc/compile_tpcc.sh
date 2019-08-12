#!/bin/bash

set -x

src_dir=`readlink -f ../../`
cur_dir=`readlink -f ./`
tpcc_path=$src_dir/tpcc-sqlite
tpcc_build_path=$tpcc_path/src
pmem_dir=/mnt/pmem_emul

cd $tpcc_build_path
make clean
make

cd $tpcc_path
sudo cp ./schema2/tpcc.db $pmem_dir/
sudo ./tpcc_load -w 4

mkdir ./database
sudo cp /mnt/pmem_emul/tpcc.db ./database/

cd $cur_dir
