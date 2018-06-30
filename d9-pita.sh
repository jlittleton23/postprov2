#!/bin/bash -x
exec >> file
exec 2>&1

# add deploy user
#/usr/sbin/adduser --home /home/deploy --disabled-password --gecos "" deploy

#mkdir -p /home/deploy/.ssh

#echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3rUp7XVpH7WtNzwqMxltgkr3QksQlfCQ4dwekrwrrWiCyfewiEx8c1YTtVsTqioRNn40ND3kvTOv3kMkWEuf0S0xZg/40tQFX+GNM8O
Cj/VtsHcrKaGF4jwTs3lnLqPrfhsy5COTg9LDZoQry4DNjljoJUPdvLUlJeUgv0l5Yl3+a+x9RftIhFKuGOpj/1dYfYUcBttQ24aTG52opqaGGqYqGY9n6gc/LIT2C1T5Pu893MF5ZnIRD5BsoJcbYQZqeutDE1DS+bUjZiEC+UyZRbG7xEPRigo9IBAaRqT/TK9DYr11Q9iYhyT2EnOYJ1xdvu6elxz4owp1XWkWX2nxx
#devops@opstack.pipl.com" >> /home/deploy/.ssh/authorized_keys

#chown -R deploy:deploy ~deploy/


export http_proxy=http://10.121.85.237:3128
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export dns_proxy=$http_proxy
export rsync_proxy=$http_proxy

hostname

echo "uptime:"

#DEBIAN_FRONTEND=noninteractive apt-get -y  -q install sudo >>log.log 2>&1

awk '{print int($1/3600)":"int(($1%3600)/60)":"int($1%60)}' /proc/uptime >> log.log

for i in {1..120}
do
        echo $i >> log.log
        echo "$i  ##############################################################" >> log.log
        ps -efwx >> proc.log
        echo "$i  ##############################################################" >> log.log
        sleep 3
done


#  check that apt-get is over
#while true; do
#    lsof | grep "apt-get"
#    if [ $? -eq 1 ]; then
#        break
#    fi
#    sleep 5
#    echo `date` >> /log.log
#done

#sleep 500
# install sudo
#echo "NTP=time.service.softlayer.com" >> /etc/systemd/timesyncd.conf
#systemctl restart systemd-timesyncd.service
#DEBIAN_FRONTEND=noninteractive apt-get -y  -q install sudo >>log.log 2>&1
#/usr/sbin/usermod -G sudo deploy >>log.log 2>&1
#echo 'deploy  ALL=(ALL)       NOPASSWD: ALL' /etc/sudoers >> /etc/sudoers 2> /tmp/provis.log
