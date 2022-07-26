# CUE vs Ansible 
Exploring the following topics:

* Comparing CUE with Ansible
* Migrating from Ansible to CUE
    * [Using CUE to validate Ansible host variables](./validation)
    * [Migrating Jinja template to CUE and using CUE scripting for inventory management.](./jinja)
    * [Data transformation with CUE](./transformation)


## Resource Utilisation Comparison

> Memory utilisation is measured with mprof since `time` doesn't catch the memory used by Ansible's forked processes.

### Configuring a single device

Average CPU, time and max peak memory over 10 measurements:

| A/C | CPU% | Max Mem (MB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| [Ansible (HTTP)](./test-results/ansible.csv) | 82 | [131.820](./mprofile_ansible.dat) | 00:02.7 |
| [CUE](./test-results/cue.csv) (API) | 17 | [24.504](./mprofile_cue.dat) | 00:01.2 |


### Configuring 20 devices


Average CPU, time and max peak memory over 10 measurements:

| A/C | CPU% | Max Mem (MB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| [CUE API](./test-results/cue20.csv) | 114 | [155.230](./test-results/mprofile_cue20.dat) | 00:03.2 |
| [CUE SSH](./test-results/cue_cli20.csv) | 10 | [208.504](./test-results/mprofile_cue_cli20.dat) | 00:08.3 |
| [Ansible (HTTP)](./test-results/ansible20-http.csv) | 157 | [1927.906](./test-results/mprofile_ansible20-http.dat) | 00:10.7 |
| [Ansible (SSH)](./test-results/ansible20-csv.csv) | 32 | [1175.422]((./test-results/mprofile_ansible20-cli.dat)) | 00:08.3 |



