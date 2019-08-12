#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: sudo ./run_fs.sh <fs> <run_id>"
    exit 1
fi

set -x

workload=tpcc
fs=$1
run_id=$2
current_dir=$(pwd)
tpcc_dir=`readlink -f ../../tpcc-sqlite`
workload_dir=$tpcc_dir/database
pmem_dir=/mnt/pmem_emul
if [ "$fs" == "boost" ]; then
    boost_dir=`readlink -f ../../boost-tpcc`
elif [ "$fs" == "sync_boost" ]; then
    boost_dir=`readlink -f ../../boost-tpcc-sync`
else
    boost_dir=`readlink -f ../../boost-tpcc-posix`
fi
result_dir=`readlink -f ../../results`
fs_results=$result_dir/$fs/$workload

ulimit -c unlimited

echo Sleeping for 5 seconds . . 
sleep 5

run_workload()
{

    echo ----------------------- TPCC WORKLOAD ---------------------------

    mkdir -p $fs_results
    rm $fs_results/run$run_id

    rm -rf $pmem_dir/*
    cp $workload_dir/tpcc.db $pmem_dir && sync

    sleep 5

    date

    time $boost_dir/run_boost.sh -p $boost_dir -t nvp_nvp.tree $tpcc_dir/tpcc_start -w 4 -c 1 -t 200000 2>&1 | tee $fs_results/run$run_id

    date

    echo Sleeping for 5 seconds . .
    sleep 5

}


run_workload

cd $current_dir
