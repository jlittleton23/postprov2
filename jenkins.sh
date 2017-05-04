#!/bin/bash -x
#
# 1. install git
# 2. download repo
# 3. invoke newrelic
# 4. invoke docker
# 5. invoke NTP(Network Time Protocol)
# 6. invoke setup user

set -x

REPO_DIR=/tmp/ucdaas-hardening-scripts
DONE_FILE=/tmp/taas-bootstrap.done
LOG_FILE=/tmp/taas-bootstrap.log

# This line will be replaced by specific branch by Jenkins build
BRANCH=master

cleanAptCache() {
	if [ -f /etc/debian_version ]; then
	  # Address http://askubuntu.com/questions/41605/trouble-downloading-packages-list-due-to-a-hash-sum-mismatch-error in case of broken apt mirror
	  rm -rf /var/lib/apt/lists/*
	  apt-get update -y
	fi
}

installCurl() {
	if [ -f /etc/debian_version ]; then
		apt-get update -y && apt-get install -y curl
	elif [ -f /etc/redhat-release ]; then
		yum install -y curl
	fi
}

installGit() {
	if [ -f /etc/debian_version ]; then
		apt-get update -y && apt-get install -y git
	elif [ -f /etc/redhat-release ]; then

		if grep -q ' 7.' "/etc/redhat-release"; then
		    # RHEL7-specific packages
			wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -O epel-release-latest-7.noarch.rpm
			rpm -ivh --force epel-release-latest-7.noarch.rpm
			yum install -y git

		elif grep -q ' 6.' "/etc/redhat-release"; then
			# RHEL6-specific packages
			wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm -O epel-release-latest-6.noarch.rpm
			rpm -ivh --force epel-release-latest-6.noarch.rpm
			# rpm -i 'http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm'
			rpm -ivh http://mirror.us.leaseweb.net/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
			# Install Git >= 1.7.12 from rpmforge to make sure it works with jenkins git plugin option 'git config --local'
			yum install -y git --enablerepo=rpmforge-extras
		fi
	else
	    echo "OS not supported!"
	    exit 1
	fi
}


downloadRepo() {
	rm -rf $REPO_DIR
	mkdir -p $REPO_DIR
	git clone -b $BRANCH https://devopsax:fa1ade64faea9b6649571f94b5bf177c319b8c25@github.ibm.com/Cloud-DevOps-Transformation-Services/ucdaas-hardening-scripts.git $REPO_DIR

	chmod +x $REPO_DIR/*.sh
}

installNewRelic(){
	cd $REPO_DIR
	./newrelic.sh
}

installDocker(){
	cd $REPO_DIR
	./docker.sh
}
#Install NTP package and update time servers
installNTP(){
	cd $REPO_DIR
	./ntp-install.sh
}

setupUser() {
	cd $REPO_DIR
	./hardenjenkinsserver.sh
}

addDns() {
	cd $REPO_DIR
	./adddns.sh
}

jobDone(){
	touch $DONE_FILE
}

cleanup(){
	rm -rf $DONE_FILE
}

setGateway(){
	# Setting gateway will fail for servers outside of our SL account
	if ping -W5 -c1 rs1.service.softlayer.com; then
		curl -sSL https://files.swg-devops.com/bootstrap/setgateway.sh | sudo bash
	fi
}

run(){
	cleanup
	cleanAptCache
	installCurl
	setGateway
	installGit
	downloadRepo
	addDns
	installNewRelic
	installDocker
	installNTP
	setupUser
	jobDone
}

time run 2>&1 | tee $LOG_FILE
