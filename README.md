# CUE vs Ansible 
Exploring the following topics:

* Comaring CUE with Ansible
* Migrating from Ansible to CUE


## Speed Comparison

Test against a single local `cvx` device:

```
➜  cue-ansible git:(main) ✗ make ansible
time ansible-playbook --extra-vars 'MSG=1658761558' nvidia.nvue_cli.foo
[WARNING]: running playbook inside collection nvidia.nvue_cli

PLAY [Test] ******************************************************************************************************************************************************************************************************************************************************************

TASK [Set system pre-login message] ******************************************************************************************************************************************************************************************************************************************
Monday 25 July 2022  16:05:59 +0100 (0:00:00.014)       0:00:00.014 ***********
ok: [cumulus]

PLAY RECAP *******************************************************************************************************************************************************************************************************************************************************************
cumulus                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Monday 25 July 2022  16:06:05 +0100 (0:00:05.977)       0:00:05.992 ***********
===============================================================================
Set system pre-login message ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 5.98s
1.08user 0.13system 0:06.55elapsed 18%CPU (0avgtext+0avgdata 46056maxresident)k
0inputs+512outputs (0major+42270minor)pagefaults 0swaps
```

The same action but performed directly over NVUE API:

```
➜  cue-ansible git:(main) ✗ make cue
time cue apply
PATCH RESPONSE: {
  "system": {
    "message": {
      "pre-login": "1658761576"
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

0.11user 0.01system 0:00.43elapsed 28%CPU (0avgtext+0avgdata 25884maxresident)k
0inputs+0outputs (0major+2239minor)pagefaults 0swaps
```

