#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: sudo $0 <LoadA/RunA/RunB/RunC/RunF/RunD> <boost> <run_id>"
    exit 1
fi

set -x

workload=$1
setup=$2
run_id=$3
current_dir=$(pwd)
leveldb_dir=`readlink -f ../../leveldb`
leveldb_build_dir=$leveldb_dir/build
database_dir=/mnt/pmem_emul/leveldbtest-1000
workload_dir=$leveldb_dir/ycsb_workloads
pmem_dir=/mnt/pmem_emul
result_dir=`readlink -f ../../results`
boost_results=$result_dir/$setup/$workload
boost_dir=`readlink -f ../../boost-ycsb`
if [ "$setup" == "boost" ]; then
    boost_dir=`readlink -f ../../boost-ycsb`
elif [ "$setup" == "sync_boost" ]; then
    boost_dir=`readlink -f ../../boost-ycsb-sync`
else
    boost_dir=`readlink -f ../../boost-ycsb-posix`
fi

ulimit -c unlimited

echo Sleeping for 5 seconds . .
sleep 5

load_workload()
{
    tracefile=$1

    echo ----------------------- LevelDB YCSB Load $workloadName ---------------------------

    # Clear the database directory
    rm -rf $database_dir

    export trace_file=$tracefile
    echo Trace file is $trace_file

    mkdir -p $boost_results
    rm $boost_results/run$run_id

    date

    $boost_dir/run_boost.sh -p $boost_dir -t nvp_nvp.tree $leveldb_build_dir/db_bench --use_existing_db=0 --benchmarks=ycsb,stats,printdb --db=$database_dir --threads=1 --open_files=1000 2>&1 | tee $boost_results/run$run_id

    date

    echo Sleeping for 5 seconds . .
    sleep 5

    rm $pmem_dir/*

    sleep 5
}

run_workload()
{
    tracefile=$1

    echo ----------------------- LevelDB YCSB Run $workloadName ---------------------------

    export trace_file=$tracefile
    echo Trace file is $trace_file

    mkdir -p $boost_results
    rm $boost_results/run$run_id

    date

    $boost_dir/run_boost.sh -p $boost_dir -t nvp_nvp.tree $leveldb_build_dir/db_bench --use_existing_db=1 --benchmarks=ycsb,stats,printdb --db=$database_dir --threads=1 --open_files=1000 2>&1 | tee $boost_results/run$run_id

    date

    echo Sleeping for 5 seconds . .
    sleep 5

    rm $pmem_dir/*

    sleep 5
}


case "$workload" in
    LoadA)
        trace_file=$workload_dir/loada_5M
        load_workload $trace_file
        ;;

    RunA)
        trace_file=$workload_dir/runa_5M_5M
        run_workload $trace_file
        ;;

    RunB)
        trace_file=$workload_dir/runb_5M_5M
        run_workload $trace_file
        ;;

    RunC)
        trace_file=$workload_dir/runc_5M_5M
        run_workload $trace_file
        ;;

    RunF)
        trace_file=$workload_dir/runf_5M_5M
        run_workload $trace_file
        ;;

    RunD)
        trace_file=$workload_dir/rund_5M_5M
        run_workload $trace_file
        ;;

    LoadE)
        trace_file=$workload_dir/loade_5M
        load_workload $trace_file
        ;;

    RunE)
        trace_file=$workload_dir/rune_5M_1M
        run_workload $trace_file
        ;;
    *)
        echo $"Usage: sudo $0 {LoadA/RunA/RunB/RunC/RunF/RunD} {boost} {run_id}"
        exit 1
esac

cd $current_dir
