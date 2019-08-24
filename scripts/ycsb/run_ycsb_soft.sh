#!/bin/bash

src_dir=`readlink -f ../../`
cur_dir=`readlink -f ./`
setup_dir=`readlink -f ../configs`
pmem_dir=/mnt/pmem_emul

run_ycsb()
{
    fs=$1
    for run in 1
    do
        sudo rm -rf $pmem_dir/*
        sudo taskset -c 0-7 ./run_fs_soft.sh LoadA $fs $run
        sleep 5
        sudo taskset -c 0-7 ./run_fs_soft.sh RunA $fs $run
        sleep 5
    done
}

:'
sudo $setup_dir/dax_config.sh
run_ycsb dax

sudo $setup_dir/nova_relaxed_config.sh
run_ycsb relaxed_nova

sudo $setup_dir/pmfs_config.sh
run_ycsb pmfs

sudo $setup_dir/nova_config.sh
run_ycsb nova
'
sudo $setup_dir/dax_config.sh
run_ycsb boost

:'
sudo $setup_dir/dax_config.sh
run_ycsb_boost sync_boost

cd $setup_dir
sudo $setup_dir/nova_config.sh
cd $current_dir

sudo $setup_dir/dax_config.sh
run_ycsb_boost posix_boost
'
