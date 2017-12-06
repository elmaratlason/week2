#!/usr/bin/env bash

sudo exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum -y remove java-1.7.0-openjdk
sudo yum -y install java-1.8.0

sudo yum -y install docker
sudo yum -y install docker-compose

sudo service docker start
sudo usermod -a -G docker ec2-user

sudo yum install jenkins -y
sudo usermod -a -G docker jenkins

sudo service jenkins start

# install git client
sudo yum install git

# not used, instead use oneliner below 
# curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
# sudo yum -y install node

# install nodejs and jpm
sudo yum install nodejs npm --enablerepo=epel

# install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

# install correct version of nvm
nvm install 6.9.1



touch ec2-init-done.markerfile
