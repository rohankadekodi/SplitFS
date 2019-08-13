## artifact-splitfs

---

### System Requirements

1. Ubuntu 16.04
2. Greater than or equal to 32 GB DRAM
3. At least 4 cores

### Dependencies

1. kernel: Installing the linux kernel 4.13.0 involves installing `bc`, `libelf-dev` and `libncurses5-dev`. For ubuntu, please run the script `dependencies/kernel_deps.sh`
2. LevelDB: Compiling LevelDB requires installing cmake version > 3.9. For ubuntu, please run the script `dependencies/leveldb_deps.sh`
3. YCSB: Compiling YCSB requires installing Oracle JDK 8 as well as installing maven version 3. JDK can be downloaded from [this link](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html). Please follow the steps below:
    * Download Java SE Development Kit 8u221 for Linux x64 (filename: jdk-8u221-linux-x64.tar.gz). This involves creating a free user account on Oracle.
    * $mkdir /opt/jdk
    * $tar -xf jdk-8u221-linux-x64.tar.gz -C /opt/jdk
    * $update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_221/bin/java 100
    * $update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_221/bin/javac 100
    * Check installation using java -version
4. SplitFS: Compiling SplitFS requires installing `Boost`. For Ubuntu, please run the script `dependencies/splitfs_deps.sh`

### Setup

1. kernel: `scripts/kernel-setup/compile_kernel.sh` -- This will compile the Linux 4.13.0 kernel along with loadable modules for NOVA and PMFS. It will also install the kernel after compiling. Run with `sudo` 
2. PM Emulation: 
    * Open `/etc/default/grub`
    * add `GRUB_CMDLINE_LINUX="memmap=24G!4G nokaslr"`
    * `sudo update-grub && sudo update-grub2`
    * Reboot system
    * Run `uname -r` to ensure that system is booted with 4.13.0 kernel, and ensure that `/dev/pmem0` exists
3. SplitFS: `scripts/splitfs/compile_splitfs.sh` -- This will compile splitfs strict
4. LevelDB: `scripts/ycsb/compile_leveldb.sh` -- This will compile LevelDB
5. YCSB: `scripts/ycsb/compile_ycsb.sh` -- This will compile YCSB workload
6. SQLite: `scripts/tpcc/compile_sqlite.sh` -- This will compile SQLite3
7. TPCC: `scripts/tpcc/compile_tpcc.sh` -- This will compile TPCC workload
8. rsync: `scripts/rsync/compile_rsync.sh` -- This will compile rsync

### Workload Generation

1. YCSB: `scripts/ycsb/gen_workloads.sh` -- This will generate the YCSB workload files to be run with LevelDB, because YCSB does not natively support LevelDB, and has been added to the benchmarks of LevelDB
2. TPCC: `scripts/tpcc/gen_workload.sh` -- This will create an initial database on SQLite on which to run the TPCC workload
3. rsync: `scripts/rsync/rsync_gen_workload.sh` -- This will create the rsync workload according to the backup data distribution as mentioned in the Paper

### Run YCSB

1. YCSB: `scripts/ycsb/run_ycsb.sh` -- This will run all the YCSB workloads on LevelDB (Load A, Run A-F, Load E, Run E) with `ext4-DAX, NOVA strict, NOVA Relaxed, PMFS, splitfs-strict` 
2. TPCC: `scripts/tpcc/run_tpcc.sh` -- This will run the TPCC workload on SQLite3 with `ext4-DAX, NOVA strict, NOVA Relaxed, PMFS, splitfs-strict`
3. rsync: `scripts/rsync/run_rsync.sh` -- This will run the rsync workload with `ext4-DAX, NOVA strict, NOVA Relaxed, PMFS, splitfs-strict`

Note: Run all the workloads using `$taskset -c 0-7 <filename>.sh`. This will restrict the workloads to cores 0-7 of the system. This is essential for less variance in the performance. 

### Results

Results will be generated in `results/` folder in the repository

### Replicating Results

The setup used for the Paper was a server with Ubuntu 16.04, 32GB DRAM, 4 cores and 1 socket. Processor used: Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz. LLC cache = 8 MB.

### Contact

In case of any difficulties, please send an e-mail to `rak@cs.utexas.edu`
