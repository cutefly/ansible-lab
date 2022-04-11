# Ansible Lab

> https://kibbomi.tistory.com/258

## 환경 구성

```sh
1. ansible-worker
$ docker run -d -it --name ansible_worker1 ubuntu
$ docker run -d -it --name ansible_worker2 ubuntu

$ docker exec -it ansible_worker1 bash
# apt update
# apt install openssh-server
locale : Asis/Seoul

# apt install vim
# vi /etc/ssh/sshd_config
Port 22
PermitRootLogin yes

# service ssh restart

# passwd (choi)


2. ansible-server
$ docker run -d -it --name ansible_server ubuntu

$ docker exec -it ansible_server bash
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

## Execute shell script

```yaml
---
- hosts: all
  tasks:
    - name: copying file with playbook
      copy:
        src: ~/collect.sh
        dest: /tmp/
        owner: root
        group: root
        mode: 0744
    - name: execute shell script
      #    shell: ./collect.sh > result/result_$(hostname)_$(date +"%Y-%m-%d").txt
      shell: sh collect.sh > result/result_{{ inventory_hostname }}.txt
      args:
        chdir: /tmp
    - name: copying result file with shel execute
      fetch:
        src: /tmp/result/result_{{ inventory_hostname }}.txt
        dest: /root/result/
        flat: yes

$ ansible-playbook playbook-shell.yaml
```
