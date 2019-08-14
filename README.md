## artifact-splitfs

---

### Contents

1. `splitfs/` contains the source code for SplitFS-strict
2. `dependencies/` contains packages and scripts to resolve dependencies
3. `kernel/` contains the Linux 4.13.0 kernel
4. `leveldb/` contains LevelDB source code
5. `rsync/` contains the rsync source code
6. `scripts/` contains scripts to compile and run workloads and kernel
7. `splitfs-so/` contains the SplitFS-strict shared libraries for running different workloads
8. `sqlite3-trace/` contains SQLite3 source code
9. `tpcc-sqlite/` contains TPCC source code
10. `ycsb/` contains YCSB source code

---

### System Requirements

1. Ubuntu 16.04
2. At least 32 GB DRAM
3. At least 4 cores
4. Baremetal machine (Not a VM)
5. Intel Processor supporting `clflushopt` instruction (Introduced in Intel processor family -- Broadwell). This can be verified with `lscpu | grep clflushopt`

---

### Dependencies

1. kernel: Installing the linux kernel 4.13.0 involves installing `bc`, `libelf-dev` and `libncurses5-dev`. For ubuntu, please run the script `cd dependencies; ./kernel_deps.sh; cd ..`
2. LevelDB: Compiling LevelDB requires installing cmake version > 3.9. For ubuntu, please run `cd dependencies; ./leveldb_deps.sh; cd ..`
3. YCSB: Compiling YCSB requires installing JDK 8 as well as installing maven version 3. Please follow the steps below:
    * `$ sudo add-apt-repository ppa:openjdk-r/ppa`
    * `$ sudo apt update`
    * `$ sudo apt install openjdk-8-jdk`
    * `$ export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64`
    * `$ export PATH=$PATH:$JAVA_HOME/bin`
    * Check installation using `java -version`
    * `$ sudo apt install maven`
4. SplitFS: Compiling SplitFS requires installing `Boost`. For Ubuntu, please run `cd dependencies; ./splitfs_deps.sh; cd ..`

---

### Setup

1. kernel: `cd scripts/kernel-setup; ./compile_kernel.sh; cd ..` -- This will compile the Linux 4.13.0 kernel along with loadable modules for NOVA and PMFS. It will also install the kernel after compiling. Run with `sudo` 
2. PM Emulation: 
    * Open `/etc/default/grub`
    * add `GRUB_CMDLINE_LINUX="memmap=24G!4G nokaslr"`
    * Close file
    * `$ sudo update-grub && sudo update-grub2`
    * Reboot system
    * Run `uname -r` to ensure that system is booted with 4.13.0 kernel, and ensure that `/dev/pmem0` exists
    * `$ mkdir /mnt/pmem_emul`
3. SplitFS: `cd scripts/splitfs; ./compile_splitfs.sh; cd ../..` -- This will compile splitfs strict
4. LevelDB: `cd scripts/ycsb; ./compile_leveldb.sh; cd ../..` -- This will compile LevelDB
5. YCSB: `cd scripts/ycsb; ./compile_ycsb.sh; cd ../..` -- This will compile YCSB workload
6. SQLite: `cd scripts/tpcc; ./compile_sqlite.sh; cd ../..` -- This will compile SQLite3
7. TPCC: `cd scripts/tpcc; ./compile_tpcc.sh; cd ../..` -- This will compile TPCC workload
8. rsync: `cd scripts/rsync; ./compile_rsync.sh; cd ../..` -- This will compile rsync

---

### Workload Generation

1. YCSB: `cd scripts/ycsb; ./gen_workloads.sh; cd ../..` -- This will generate the YCSB workload files to be run with LevelDB, because YCSB does not natively support LevelDB, and has been added to the benchmarks of LevelDB
2. TPCC: `cd scripts/tpcc; ./gen_workload.sh; cd ../..` -- This will create an initial database on SQLite on which to run the TPCC workload
3. rsync: `cd scripts/rsync/; sudo ./rsync_gen_workload.sh; cd ../..` -- This will create the rsync workload according to the backup data distribution as mentioned in the Paper

---

### Run Workloads

1. YCSB: `cd scripts/ycsb; ./run_ycsb.sh; cd ../..` -- This will run all the YCSB workloads on LevelDB (Load A, Run A-F, Load E, Run E) with `ext4-DAX, NOVA strict, NOVA Relaxed, PMFS, SplitFS-strict` 
2. TPCC: `cd scripts/tpcc; ./run_tpcc.sh; cd ../..` -- This will run the TPCC workload on SQLite3 with `ext4-DAX, NOVA strict, NOVA Relaxed, PMFS, SplitFS-POSIX`
3. rsync: `cd scripts/rsync; ./run_rsync.sh; cd ../..` -- This will run the rsync workload with `ext4-DAX, NOVA strict, NOVA Relaxed, PMFS, SplitFS-sync`

---

### Results

Results will be generated in `results/` folder in the repository

---

### Replicating Results

The setup used for the Paper was a server with Ubuntu 16.04, 32GB DRAM, 4 cores and 1 socket. Processor used: Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz. LLC cache = 8 MB.

---

### Contact

In case of any difficulties, please send an e-mail to `rak@cs.utexas.edu`
