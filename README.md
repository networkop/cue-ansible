# CUE vs Ansible 
Exploring the following topics:

* Comparing CUE with Ansible
* Migrating from Ansible to CUE


## Resource Utilisation Comparison

### Configuring a single device

[Ansible Results](./ansible.csv)
[CUE Results](./cue.csv)

Average over 10 measurements:

| A/C | CPU% | Max Mem (kB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| Ansible | 75 | 51755.2 | 00:04.0 |
| CUE | 17 | 24788 | 00:01.2 |


### Configuring 20 devices

Ansible (HTTP) plugin was extremely unstable due to limited RAM (1G). The only successful strategy was to run it with fork=1 and even then it failed on 1 out of 20 switches. This is most likely due to non-persistent connections and the cost of 3 API calls per playbook.

Average over 10 measurements:

| A/C | CPU% | Max Mem (kB) | Time (mm:ss.0) | 
| ----|------|--------------|------|
| CUE | 74 | 190659.6 | 00:03.2 |
| Ansible (HTTP) | 47 | 56419.2 | 00:38.0 |
| Ansible (SSH) | 33 | 52049.2 | 00:08.6 |

[Ansible Results (HTTP)](./ansible20-http.csv)
[Ansible Results (SSH)](./ansible20-csv.csv)
[CUE Results](./cue20.csv)


