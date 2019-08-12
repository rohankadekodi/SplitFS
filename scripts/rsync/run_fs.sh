#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: sudo ./run_fs.sh <fs> <run_id>"
    exit 1
fi

set -x

workload=rsync
fs=$1
run_id=$2
current_dir=$(pwd)
rsync_dir=`readlink -f ../../rsync`
workload_dir=$rsync_dir/workload
pmem_dir=/mnt/pmem_emul
boost_dir=`readlink -f ../../boost-rsync`
result_dir=`readlink -f ../../results`
fs_results=$result_dir/$fs/$workload

ulimit -c unlimited

echo Sleeping for 5 seconds . . 
sleep 5

run_workload()
{

    echo ----------------------- RSYNC WORKLOAD ---------------------------

    mkdir -p $fs_results
    rm $fs_results/run$run_id

    rm -rf $pmem_dir/*
    cp -r $workload_dir/src $pmem_dir && sync

    cd $pmem_dir
    mkdir dest

    sleep 5

    date

    time $rsync_dir/rsync -Wr ./src dest/ 2>&1 | tee $fs_results/run$run_id

    date

    cd $current_dir

    echo Sleeping for 5 seconds . .
    sleep 5

}


run_workload

cd $current_dir
