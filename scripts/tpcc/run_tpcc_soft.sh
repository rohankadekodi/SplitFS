#!/bin/bash

cur_dir=`readlink -f ./`
src_dir=`readlink -f ../../`
setup_dir=$src_dir/scripts/configs
pmem_dir=/mnt/pmem_emul

run_tpcc()
{
    fs=$1
    for run in 1
    do
        sudo rm -rf $pmem_dir/*
        sudo taskset -c 0-7 ./run_fs_soft.sh $fs $run
        sleep 5
    done
}

sudo $setup_dir/dax_config.sh
run_tpcc dax

sudo $setup_dir/nova_relaxed_config.sh
run_tpcc relaxed_nova

sudo $setup_dir/pmfs_config.sh
run_tpcc pmfs

sudo $setup_dir/nova_config.sh
run_tpcc nova

sudo $setup_dir/dax_config.sh
run_tpcc boost

sudo $setup_dir/dax_config.sh
run_tpcc sync_boost

sudo $setup_dir/dax_config.sh
run_tpcc posix_boost
