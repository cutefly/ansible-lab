#!/bin/sh
HOSTNAME=`hostname`
DATE=`date -I`

#LANG=C
#export LANG

echo ========= KPC Linux System / Security Check is Start =========
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 1/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 시스템 설치일                                                                                            " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " [CentOS]"                                                                                                  >>$HOSTNAME-$DATE.txt
ls -l --time-style full-iso /root/anaconda-ks.cfg                                                                 >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt
echo " [Ubuntu]"                                                                                                  >>$HOSTNAME-$DATE.txt
ls -l --time-style full-iso /var/log/installer/syslog                                                             >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 2/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 시스템 부트일                                                                                            " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
who -b                                                                                                            >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 3/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 시스템 가동일                                                                                            " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
uptime                                                                                                            >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 4/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 날짜/시간                                                                                                " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " ■ 시간 설정 정보                                                                                         " >>$HOSTNAME-$DATE.txt
cat /etc/ntp.conf | grep server                                                                                   >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt
echo " ■ NTP 서버와 시간차                                                                                      " >>$HOSTNAME-$DATE.txt
/usr/sbin/ntpq -p                                                                                                           >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 5/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " CPU, 메모리 사용률 확인                                                                                  " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " ■ Physical 메모리 정보                                                                                   " >>$HOSTNAME-$DATE.txt
vmstat -s -S M                                                                                                    >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt
echo " ■ 20초 동안 CPU 사용률                                                                                   " >>$HOSTNAME-$DATE.txt
vmstat -S M 2 20                                                                                                  >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 6/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 디스크 사용률 확인                                                                                       " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
lsblk                                                                                                             >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt
df -hP                                                                                                            >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 7/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " root 계정 ssh 직접 접속 가능 여부 확인                                                                   " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
cat /etc/ssh/sshd_config | grep "PermitRootLogin"                                                                 >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 8/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 불필요한 계정 존재 여부 확인                                                                             " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " ■ Shell 로그인 가능 계정                                                                                 " >>$HOSTNAME-$DATE.txt
cat /etc/passwd | grep /bin/bash                                                                                  >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt
echo " ■ Lastlog                                                                                                " >>$HOSTNAME-$DATE.txt
lastlog                                                                                                           >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 9/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 계정 잠금 임계값 확인                                                                                    " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " [CentOS]"                                                                                                  >>$HOSTNAME-$DATE.txt
echo "/etc/pam.d/system-auth"                                                                                     >>$HOSTNAME-$DATE.txt
cat /etc/pam.d/system-auth | grep "deny="                                                                         >>$HOSTNAME-$DATE.txt
echo "/etc/pam.d/password-auth"                                                                                   >>$HOSTNAME-$DATE.txt
cat /etc/pam.d/password-auth | grep "deny="                                                                       >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt
echo " [Ubuntu]"                                                                                                  >>$HOSTNAME-$DATE.txt
cat /etc/pam.d/common-auth | grep "deny="                                                                         >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 10/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 관리자 그룹 계정 확인                                                                                    " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
cat /etc/group                                                                                                    >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 11/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 관리자 계정 암호 변경일 확인                                                                             " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
chage -l root                                                                                                     >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 12/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " OS 방화벽 사용 여부 확인                                                                                 " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " [CentOS]"                                                                                                  >>$HOSTNAME-$DATE.txt
service iptables status                                                                                           >>$HOSTNAME-$DATE.txt
systemctl status firewalld.service                                                                                >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo " [Ubuntu]"                                                                                                  >>$HOSTNAME-$DATE.txt
ufw status verbose                                                                                                >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 13/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 접속 IP 및 포트 제한 확인                                                                                " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " [CentOS]"                                                                                                  >>$HOSTNAME-$DATE.txt
cat /etc/sysconfig/iptables                                                                                       >>$HOSTNAME-$DATE.txt                                                                                             >>$HOSTNAME-$DATE.txt
firewall-cmd --list-all                                                                                           >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo " [Ubuntu]"                                                                                                  >>$HOSTNAME-$DATE.txt
ufw app list                                                                                                      >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 14/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " Session Timeout 설정 확인                                                                                " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
cat /etc/profile | grep TMOUT                                                                                     >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 15/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " DNS 서버 확인                                                                                            " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
cat /etc/resolv.conf                                                                                              >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 16/20  ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " LISTEN 포트 확인                                                                                         " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
netstat -anp | grep "LISTEN"                                                                                      >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 17/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 실행중인 서비스 확인                                                                                     " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
pstree -apu                                                                                                       >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt
ps -ef                                                                                                            >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 18/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 시스템 로그 확인                                                                                         " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
dmesg | tail                                                                                                      >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 19/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " NAS 연결 유무 확인                                                                                       " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
df -h                                                                                                             >>$HOSTNAME-$DATE.txt
cat /etc/fstab                                                                                                    >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo [ Checking 20/20 ]
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
echo " 점검일자                                                                                                 " >>$HOSTNAME-$DATE.txt
echo "==========================================================================================================" >>$HOSTNAME-$DATE.txt
date                                                                                                              >>$HOSTNAME-$DATE.txt
echo >> $HOSTNAME-$DATE.txt

echo ========= KPC Linux System / Security Check is End =========
