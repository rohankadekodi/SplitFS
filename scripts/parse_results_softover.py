import csv

boost_ycsb_files = ['../results/boost/LoadA/run_soft_over_1', '../results/boost/RunA/run_soft_over_1']
boost_ycsb_sync_files = ['../results/sync_boost/LoadA/run_soft_over_1', '../results/sync_boost/RunA/run_soft_over_1']
boost_ycsb_posix_files = ['../results/posix_boost/LoadA/run_soft_over_1', '../results/posix_boost/RunA/run_soft_over_1']
nova_ycsb_files = ['../results/nova/LoadA/run_soft_over_1', '../results/nova/RunA/run_soft_over_1']
relaxed_nova_ycsb_files = ['../results/relaxed_nova/LoadA/run_soft_over_1', '../results/relaxed_nova/RunA/run_soft_over_1']
pmfs_ycsb_files = ['../results/pmfs/LoadA/run_soft_over_1', '../results/pmfs/RunA/run_soft_over_1']
dax_ycsb_files = ['../results/dax/LoadA/run_soft_over_1', '../results/dax/RunA/run_soft_over_1']

boost_tpcc_file = ['../results/boost/tpcc/run_soft_over_1']
boost_tpcc_sync_file = ['../results/sync_boost/tpcc/run_soft_over_1']
boost_tpcc_posix_file = ['../results/posix_boost/tpcc/run_soft_over_1']
nova_tpcc_file = ['../results/nova/tpcc/run_soft_over_1']
relaxed_nova_tpcc_file = ['../results/relaxed_nova/tpcc/run_soft_over_1']
pmfs_tpcc_file = ['../results/pmfs/tpcc/run_soft_over_1']
dax_tpcc_file = ['../results/dax/tpcc/run_soft_over_1']


def get_dev_time(filenames, check_word, rel_index):
    results = []
    for file in filenames:
        with open(file, 'rt') as f:
            words = f.read().split()
            for word in words:
                if check_word in word:
                    if rel_index is 0:
                        results.append(word)
                        break
                    else:
                        results.append(words[words.index(word) + rel_index])
                        break
    return results

def get_softover_time(system, files, check_word, rel_index):
    results = []
    results.append(system)
    for file in files:
        with open(file, 'rt') as f:
            words = f.read().split()
            for word in words:
                if check_word in word:
                    if rel_index is 0:
                        results.append(word)
                        break
                    else:
                        results.append(words[words.index(word) + rel_index])
                        break
    return results

def write_csv(result, file, csv_header):
    with open(file, "w", newline="") as f:
        writer = csv.writer(f, delimiter=',')
        writer.writerow(csv_header)
        writer.writerows(result)


if __name__ == "__main__":
    all_results = []

    device_times_strict = get_dev_time(boost_ycsb_files, "device", 3)
    device_times_sync = get_dev_time(boost_ycsb_sync_files, "device", 3)
    device_times_posix = get_dev_time(boost_ycsb_posix_files, "device", 3)

    boost_results = get_softover_time("splitfs-strict", boost_ycsb_files, "soft_overhead", 3)
    sync_boost_results = get_softover_time("splitfs-sync", boost_ycsb_sync_files, "soft_overhead", 3)
    posix_boost_results = get_softover_time("splitfs-POSIX", boost_ycsb_posix_files, "soft_overhead", 3)
    nova_results = get_softover_time("nova-strict", nova_ycsb_files, "soft_overhead", 3)
    relaxed_results = get_softover_time("nova-relaxed", relaxed_nova_ycsb_files, "soft_overhead", 3)
    pmfs_results = get_softover_time("pmfs", pmfs_ycsb_files, "soft_overhead", 3)
    dax_results = get_softover_time("ext4DAX", dax_ycsb_files, "soft_overhead", 3)

    for i in range(1, len(boost_results)):
        boost_results[i] = float(boost_results[i]) - float(device_times_strict[i-1])
        sync_boost_results[i] = float(sync_boost_results[i]) - float(device_times_sync[i-1])
        posix_boost_results[i] = float(posix_boost_results[i]) - float(device_times_posix[i-1])
        nova_results[i] = float(nova_results[i]) - float(device_times_strict[i-1])
        relaxed_results[i] = float(relaxed_results[i]) - float(device_times_sync[i-1])
        pmfs_results[i] = float(pmfs_results[i]) - float(device_times_sync[i-1])
        dax_results[i] = float(dax_results[i]) - float(device_times_posix[i-1])

    all_results.append(boost_results)
    all_results.append(sync_boost_results)
    all_results.append(posix_boost_results)
    all_results.append(nova_results)
    all_results.append(relaxed_results)
    all_results.append(pmfs_results)
    all_results.append(dax_results)

    csv_header = ['System', 'Load A Time', 'Run A Time']
    write_csv(all_results, "ycsb_softover.csv", csv_header)

    boost_results.clear()
    sync_boost_results.clear()
    posix_boost_results.clear()
    nova_results.clear()
    relaxed_results.clear()
    pmfs_results.clear()
    dax_results.clear()
    all_results.clear()

    device_times_strict = get_dev_time(boost_tpcc_file, "device", 3)
    device_times_sync = get_dev_time(boost_tpcc_sync_file, "device", 3)
    device_times_posix = get_dev_time(boost_tpcc_posix_file, "device", 3)

    boost_results = get_softover_time("splitfs-strict", boost_tpcc_file, "soft_overhead", 3)
    sync_boost_results = get_softover_time("splitfs-sync", boost_tpcc_sync_file, "soft_overhead", 3)
    posix_boost_results = get_softover_time("splitfs-POSIX", boost_tpcc_posix_file, "soft_overhead", 3)
    nova_results = get_softover_time("nova-strict", nova_tpcc_file, "soft_overhead", 3)
    relaxed_results = get_softover_time("nova-relaxed", relaxed_nova_tpcc_file, "soft_overhead", 3)
    pmfs_results = get_softover_time("pmfs", pmfs_tpcc_file, "soft_overhead", 3)
    dax_results = get_softover_time("ext4DAX", dax_tpcc_file, "soft_overhead", 3)

    for i in range(1, len(boost_results)):
        boost_results[i] = float(boost_results[i]) - float(device_times_strict[i-1])
        sync_boost_results[i] = float(sync_boost_results[i]) - float(device_times_sync[i-1])
        posix_boost_results[i] = float(posix_boost_results[i]) - float(device_times_posix[i-1])
        nova_results[i] = float(nova_results[i]) - float(device_times_strict[i-1])
        relaxed_results[i] = float(relaxed_results[i]) - float(device_times_sync[i-1])
        pmfs_results[i] = float(pmfs_results[i]) - float(device_times_sync[i-1])
        dax_results[i] = float(dax_results[i]) - float(device_times_posix[i-1])

    all_results.append(boost_results)
    all_results.append(sync_boost_results)
    all_results.append(posix_boost_results)
    all_results.append(nova_results)
    all_results.append(relaxed_results)
    all_results.append(pmfs_results)
    all_results.append(dax_results)

    csv_header.clear()
    csv_header = ['System', 'Time']
    write_csv(all_results, "tpcc_softover.csv", csv_header)

    boost_results.clear()
    sync_boost_results.clear()
    posix_boost_results.clear()
    nova_results.clear()
    relaxed_results.clear()
    pmfs_results.clear()
    dax_results.clear()
    all_results.clear()
