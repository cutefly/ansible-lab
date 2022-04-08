# Ansible Lab

> https://kibbomi.tistory.com/258

## 환경 구성

```sh
1. ansible-worker
$docker run -d -it --name ansible-worker1 ubuntu
$docker run -d -it --name ansible-worker2 ubuntu

$ docker exec -it ansible-worker1 bash
# apt update
# apt install openssh-server
locale : Asis/Seoul

# apt install vim
Port 22
PermitRootLogin yes

# passwd (choi)


2. ansible-server
$ docker run -d -it --name ansible-server ubuntu

$ docker exec -it ansible-worker1 bash
# apt update
# apt install ansible
# apt install vim
# vi /etc/ansible/hosts
[webserver]
172.17.0.2
172.17.0.3

# ssh-keygen
# ssh-copy-id 172.17.0.2

# vi playbook-nginx.yaml

---
- hosts: all
  tasks:
  - name: Install nginx latest version
    apt:
      name: nginx
      state: latest
      cache_valid_time: 3600
---

# ansible -m ping all
# ansible-playbook playbook-nginx.yaml
PLAY [all] *****************************************************************************************

TASK [Gathering Facts] *****************************************************************************
ok: [172.17.0.3]
ok: [172.17.0.2]

TASK [Install nginx latest version] ****************************************************************
[WARNING]: Updating cache and auto-installing missing dependency: python3-apt
changed: [172.17.0.2]
changed: [172.17.0.3]

PLAY RECAP *****************************************************************************************
172.17.0.2                 : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
172.17.0.3                 : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

# ansible-playbook playbook-nginx.yaml
PLAY [all] *****************************************************************************************

TASK [Gathering Facts] *****************************************************************************
ok: [172.17.0.3]
ok: [172.17.0.2]

TASK [Install nginx latest version] ****************************************************************
ok: [172.17.0.3]
ok: [172.17.0.2]

PLAY RECAP *****************************************************************************************
172.17.0.2                 : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
172.17.0.3                 : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
