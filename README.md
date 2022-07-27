# CUE vs Ansible 
Exploring the following topics:

* Comparing CUE with Ansible
* Migrating from Ansible to CUE


## Resource Utilisation Comparison

Test against a single local `cvx` device:

```
time ansible-playbook --extra-vars 'MSG=1658935771' nvidia.nvue.foo
[WARNING]: running playbook inside collection nvidia.nvue

PLAY [NVUE API test] *********************************************************************************************************************************************************************************************************************************************************

TASK [Set system pre-login message] ******************************************************************************************************************************************************************************************************************************************
changed: [cumulus]

PLAY RECAP *******************************************************************************************************************************************************************************************************************************************************************
cumulus                    : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

1.38user 0.15system 0:01.77elapsed 86%CPU (0avgtext+0avgdata 51396maxresident)k
0inputs+1144outputs (0major+69036minor)pagefaults 0swaps
```

The same action but performed directly over NVUE API:

```
time cue apply
PATCH RESPONSE: {
  "system": {
    "message": {
      "pre-login": "1658935788"
    }
  }
}

APPLY RESPONSE {
  "state": "apply",
  "transition": {
    "issue": {},
    "progress": ""
  }
}

0.09user 0.01system 0:00.35elapsed 30%CPU (0avgtext+0avgdata 24416maxresident)k
0inputs+0outputs (0major+1377minor)pagefaults 0swaps
```


[Ansible Results](./ansible.csv)
[CUE Results](./cue.csv)

Average over 10 measurements:

| A/C | CPU% | Max Mem (kB) | Time | 
| ----|------|--------------|------|
| Ansible | 77 | 51526.4 | 00:00:04.045 |
| CUE | 14 | 26108.8 | 00:00:01.229 |



Scaling to 20 switches

CUE:
```
2.09user 0.10system 0:02.24elapsed 97%CPU (0avgtext+0avgdata 186588maxresident)k
0inputs+0outputs (0major+61075minor)pagefaults 0swaps
```

Ansible:
```
2.70user 0.77system 0:11.54elapsed 30%CPU (0avgtext+0avgdata 52288maxresident)k
960inputs+5208outputs (16major+281475minor)pagefaults 0swaps
```



