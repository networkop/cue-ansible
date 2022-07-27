# CUE vs Ansible 
Exploring the following topics:

* Comparing CUE with Ansible
* Migrating from Ansible to CUE


## Resource Utilisation Comparison

### Configuring a single device

Average over 10 measurements:

| A/C | CPU% | Max Mem (kB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| [Ansible](./ansible.csv) | 75 | 51755.2 | 00:04.0 |
| [CUE](./cue.csv) | 17 | 24788 | 00:01.2 |


### Configuring 20 devices


Average over 10 measurements:

| A/C | CPU% | Max Mem (kB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| [CUE](./cue20.csv) | 114 | 151580.4 | 00:03.2 |
| [Ansible (HTTP)](./ansible20-http.csv) | 157 | 56401.6 | 00:10.7 |
| [Ansible (SSH)](./ansible20-csv.csv) | 42 | 52432.4 | 00:06.6 |



