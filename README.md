# CUE vs Ansible 
Exploring the following topics:

* Comparing CUE with Ansible
* Migrating from Ansible to CUE


## Resource Utilisation Comparison

> Memory utilisation is measured with mprof since `time` doesn't catch the memory used by Ansible's forked processes.

### Configuring a single device

Average CPU, time and max peak memory over 10 measurements:

| A/C | CPU% | Max Mem (MB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| [Ansible (HTTP)](./ansible.csv) | 82 | 131.820 | 00:02.7 |
| [CUE](./cue.csv) | 17 | 24.504 | 00:01.2 |


### Configuring 20 devices


Average CPU, time and max peak memory over 10 measurements:

| A/C | CPU% | Max Mem (MB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| [CUE](./cue20.csv) | 114 | 155.230 | 00:03.2 |
| [Ansible (HTTP)](./ansible20-http.csv) | 157 | 1927.906 | 00:10.7 |
| [Ansible (SSH)](./ansible20-csv.csv) | 42 | 1175.422 | 00:06.6 |



