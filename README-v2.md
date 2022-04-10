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

# service ssh restart

# useradd -m appadmin
# passwd appadmin (choi)

# apt install sudo
# usermod -aG sudo appadmin

# visudo /etc/sudoers
appadmin ALL=NOPASSWD: ALL

$ docker exec -it -u appadmin ansible_worker1 bash

2. ansible-server
$ docker run -d -it --name ansible_server ubuntu

$ docker exec -it ansible_server bash
# apt update
# apt install ansible
# apt install vim
# vi /etc/ansible/hosts
[ubuntu]
172.17.0.2
172.17.0.3

[ubuntu:vars]
ansible_ssh_user=appadmin

# ssh-keygen
# ssh-copy-id appadmin@172.17.0.2

# vi playbook-nginx.yaml

---
- hosts: all
  tasks:
  - name: Install nginx latest version
    become: true
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
      owner: appadmin
      group: appadmin
      mode: 0744
  - name: create directory
    file:
      path: /tmp/result
      state: directory
      mode: 0755
  - name: execute shell script
    become: true
    #    shell: ./collect.sh > result/result_$(hostname)_$(date +"%Y-%m-%d").txt
    shell: sh collect.sh > result/result_{{ inventory_hostname }}.txt
    args:
      chdir: /tmp
  - name: copying result file with shel execute
    fetch:
      src: /tmp/result/result_{{ inventory_hostname }}.txt
      dest: ~/result/
      flat: yes
  - name: remove files and directories
    file:
      path: /tmp/{{ item }}
      state: absent
    with_items:
      - collect.sh
      - result

$ ansible-playbook playbook-shell.yaml

# custom inventory file (ansible/hosts)
$ ansible-playbook playbook-shell.yaml -i ansible/hosts
```

## centos 추가

```
1. ansible-worker
$ docker run -d -it --name ansible_worker3 centos:7
$ docker run -d -it --name ansible_worker4 centos:7

[ Failed to get D-Bus connection: Operation not permitted 에러 발생 시 ]
$ docker run --privileged=true -d --name ansible_worker3 centos:7 /sbin/init

$ docker exec -it ansible_worker3 bash
# yum install openssh-server openssh-clients openssh-askpass
# vi /etc/ssh/sshd_config
Port 22

docker 환경에서 systemctl 실행 이슈가 있어 보류
```
