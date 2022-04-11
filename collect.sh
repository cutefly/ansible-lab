#!/bin/sh
HOSTNAME=`hostname`
DATE=`date -I`
#FILENAME=$HOSTNAME-$DATE.txt
FILENAME=result.txt

#LANG=C
#export LANG

echo ========= KPC Linux System / Security Check is Start =========
echo > $FILENAME

echo [ Checking 1/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 시스템 설치일                                                                                            " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
echo " [CentOS]"                                                                                                  >>$FILENAME
ls -l --time-style full-iso /root/anaconda-ks.cfg                                                                 >>$FILENAME
echo >> $FILENAME
echo " [Ubuntu]"                                                                                                  >>$FILENAME
ls -l --time-style full-iso /var/log/installer/syslog                                                             >>$FILENAME
echo >> $FILENAME

echo [ Checking 2/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 시스템 부트일                                                                                            " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
who -b                                                                                                            >>$FILENAME
echo >> $FILENAME

echo [ Checking 3/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 시스템 가동일                                                                                            " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
uptime                                                                                                            >>$FILENAME
echo >> $FILENAME

echo [ Checking 4/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 날짜/시간                                                                                                " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
echo " ■ 시간 설정 정보                                                                                         " >>$FILENAME
cat /etc/ntp.conf | grep server                                                                                   >>$FILENAME
echo >> $FILENAME
echo " ■ NTP 서버와 시간차                                                                                      " >>$FILENAME
/usr/sbin/ntpq -p                                                                                                           >>$FILENAME
echo >> $FILENAME

echo [ Checking 5/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " CPU, 메모리 사용률 확인                                                                                  " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
echo " ■ Physical 메모리 정보                                                                                   " >>$FILENAME
vmstat -s -S M                                                                                                    >>$FILENAME
echo >> $FILENAME
echo " ■ 20초 동안 CPU 사용률                                                                                   " >>$FILENAME
vmstat -S M 2 20                                                                                                  >>$FILENAME
echo >> $FILENAME

echo [ Checking 6/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 디스크 사용률 확인                                                                                       " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
lsblk                                                                                                             >>$FILENAME
echo >> $FILENAME
df -hP                                                                                                            >>$FILENAME
echo >> $FILENAME

echo [ Checking 7/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " root 계정 ssh 직접 접속 가능 여부 확인                                                                   " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
cat /etc/ssh/sshd_config | grep "PermitRootLogin"                                                                 >>$FILENAME
echo >> $FILENAME

echo [ Checking 8/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 불필요한 계정 존재 여부 확인                                                                             " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
echo " ■ Shell 로그인 가능 계정                                                                                 " >>$FILENAME
cat /etc/passwd | grep /bin/bash                                                                                  >>$FILENAME
echo >> $FILENAME
echo " ■ Lastlog                                                                                                " >>$FILENAME
lastlog                                                                                                           >>$FILENAME
echo >> $FILENAME

echo [ Checking 9/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 계정 잠금 임계값 확인                                                                                    " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
echo " [CentOS]"                                                                                                  >>$FILENAME
echo "/etc/pam.d/system-auth"                                                                                     >>$FILENAME
cat /etc/pam.d/system-auth | grep "deny="                                                                         >>$FILENAME
echo "/etc/pam.d/password-auth"                                                                                   >>$FILENAME
cat /etc/pam.d/password-auth | grep "deny="                                                                       >>$FILENAME
echo >> $FILENAME
echo " [Ubuntu]"                                                                                                  >>$FILENAME
cat /etc/pam.d/common-auth | grep "deny="                                                                         >>$FILENAME
echo >> $FILENAME

echo [ Checking 10/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 관리자 그룹 계정 확인                                                                                    " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
cat /etc/group                                                                                                    >>$FILENAME
echo >> $FILENAME

echo [ Checking 11/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 관리자 계정 암호 변경일 확인                                                                             " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
chage -l root                                                                                                     >>$FILENAME
echo >> $FILENAME

echo [ Checking 12/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " OS 방화벽 사용 여부 확인                                                                                 " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
echo " [CentOS]"                                                                                                  >>$FILENAME
service iptables status                                                                                           >>$FILENAME
systemctl status firewalld.service                                                                                >>$FILENAME
echo >> $FILENAME

echo " [Ubuntu]"                                                                                                  >>$FILENAME
ufw status verbose                                                                                                >>$FILENAME
echo >> $FILENAME

echo [ Checking 13/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 접속 IP 및 포트 제한 확인                                                                                " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
echo " [CentOS]"                                                                                                  >>$FILENAME
cat /etc/sysconfig/iptables                                                                                       >>$FILENAME                                                                                             >>$FILENAME
firewall-cmd --list-all                                                                                           >>$FILENAME
echo >> $FILENAME

echo " [Ubuntu]"                                                                                                  >>$FILENAME
ufw app list                                                                                                      >>$FILENAME
echo >> $FILENAME

echo [ Checking 14/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " Session Timeout 설정 확인                                                                                " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
cat /etc/profile | grep TMOUT                                                                                     >>$FILENAME
echo >> $FILENAME

echo [ Checking 15/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " DNS 서버 확인                                                                                            " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
cat /etc/resolv.conf                                                                                              >>$FILENAME
echo >> $FILENAME

echo [ Checking 16/20  ]
echo "==========================================================================================================" >>$FILENAME
echo " LISTEN 포트 확인                                                                                         " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
netstat -anp | grep "LISTEN"                                                                                      >>$FILENAME
echo >> $FILENAME

echo [ Checking 17/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 실행중인 서비스 확인                                                                                     " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
pstree -apu                                                                                                       >>$FILENAME
echo >> $FILENAME
ps -ef                                                                                                            >>$FILENAME
echo >> $FILENAME

echo [ Checking 18/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 시스템 로그 확인                                                                                         " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
dmesg | tail                                                                                                      >>$FILENAME
echo >> $FILENAME

echo [ Checking 19/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " NAS 연결 유무 확인                                                                                       " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
df -h                                                                                                             >>$FILENAME
cat /etc/fstab                                                                                                    >>$FILENAME
echo >> $FILENAME

echo [ Checking 20/20 ]
echo "==========================================================================================================" >>$FILENAME
echo " 점검일자                                                                                                 " >>$FILENAME
echo "==========================================================================================================" >>$FILENAME
date                                                                                                              >>$FILENAME
echo >> $FILENAME

echo ========= KPC Linux System / Security Check is End =========
