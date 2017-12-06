#!/bin/bash
# setup key for github

ssh -i "./ec2_instance-jenkins/jenkins.pem" ec2-user@${INSTANCE_PUBLIC_NAME}
sudo su -s /bin/bash jenkins
cd /var/lib/jenkins/
ssh-keygen
cat .ssh/id_rsa.pub
