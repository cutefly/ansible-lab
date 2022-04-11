# Ansible Lab

> https://kibbomi.tistory.com/258

## 환경 구성

### Worker node 설치

```sh
1. ansible-worker for ubuntu
$ docker run -d -it --name ansible_worker1 ubuntu
$ docker run -d -it --name ansible_worker2 ubuntu

# ansible_worker1에 shell 접속
$ docker exec -it ansible_worker1 bash

# 필요한 환경 구성
root # apt update
root # apt install openssh-server
locale : Asis/Seoul

root # apt install vim -y
root # vi /etc/ssh/sshd_config
Port 22

root # service ssh restart

root # useradd -m appadmin
root # passwd appadmin (choi)

root # apt install sudo
root # usermod -aG sudo appadmin

root # visudo /etc/sudoers
appadmin ALL=NOPASSWD: ALL

$ docker exec -it -u appadmin ansible_worker1 bash

# 일반 계정으로 sudo 실행
appadmin $ sudo apt update
```

### Server node 설치

```sh
2. ansible-server
$ docker run -d -it --name ansible_server ubuntu

# ansible_server에 shell 접속속
$ docker exec -it ansible_server bash

# 필요한 환경 구성성
root # apt update
root # apt install ansible -y
root # apt install vim -y

root # ssh-keygen
root # ssh-copy-id appadmin@172.17.0.2

# inventory 구성
root # vi /etc/ansible/hosts(또는 ~/ansible/hosts)
[ubuntu]
172.17.0.2
172.17.0.3

[ubuntu:vars]
ansible_ssh_user=appadmin

# ping 테스트
root # ansible -m ping -i ansible/hosts all
172.17.0.2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
172.17.0.3 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

root # vi playbook-nginx.yaml

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

# custom inventory file (ansible/hosts)
$ ansible-playbook playbook-shell.yaml -i ansible/hosts

# 또는 Global
$ ansible-playbook playbook-shell.yaml
```

## centos 추가

```sh
3. ansible-worker for centos
$ docker run -d -it --name ansible_worker3 centos:7
$ docker run -d -it --name ansible_worker4 centos:7
=> Failed to get D-Bus connection: Operation not permitted 에러 발생

[ Failed to get D-Bus connection: Operation not permitted 에러 발생 시 ]
참고 URL : https://jenakim47.tistory.com/47
$ docker run --privileged=true -d --name ansible_worker3 centos:7 /sbin/init
$ docker run --privileged=true -d --name ansible_worker4 centos:7 /sbin/init
=> m1 macbook air 에서는 해결 못함.

$ docker exec -it ansible_worker3 bash
root # # yum install openssh-server openssh-clients openssh-askpass -y
root # # vi /etc/ssh/sshd_config
Port 22
PermitRootLogin no

$ docker restart ansible_worker3

root # useradd -m apiadmin
root # passwd apiadmin (choi)

root # yum install sudo -y
root # usermod -aG wheel apiadmin

root # sudo visudo
apiadmin ALL=NOPASSWD: ALL

$ docker exec -it -u apiadmin ansible_worker3 bash
```

```sh
4. ansible_server에서 client 구성 설정 변경

root # ssh-copy-id apiadmin@172.17.0.5
[ 키 충돌이 발생하는 경우 : ssh-keygen -R 172.17.0.5 ]

# inventory 구성
root # vi /etc/ansible/hosts(또는 ~/ansible/hosts)
[ubuntu]
172.17.0.2
172.17.0.3

[centos]
172.17.0.5
172.17.0.6

[ubuntu:vars]
ansible_ssh_user=appadmin

[centos:vars]
ansible_ssh_user=apiadmin

# ping 테스트
root # ansible -m ping -i ansible/hosts all
root # ansible -m ping -i ansible/hosts ubuntu
root # ansible -m ping -i ansible/hosts centos

root # ansible-playbook playbook-shell.yaml -i ansible/hosts
```
