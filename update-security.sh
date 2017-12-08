#!/bin/bash
# update security settings on jenkins
# should accept argument for group name ( purpose ) ,like: ./create_ec2_stuff.sh jenkins
# elmar.atlason@gmail.com / elmar14@ru.is
# Háskólinn í Reykjavík - 2017

# SETTINGS
# my home address
HOME_IP=157.157.208.120/32
## the name of the security group
SECURITY_GROUP_NAME=jenkins${USERNAME}
## the name of the ec2 image we use:
AMI_ID=ami-e7d6c983
#AMI_ID=ami-1a962263
## in what region are we running
REGION=eu-west-2
# open http for public internet?
PUBLIC_WEB_ACCESS=false
# sleep time to create delay as we are unable to connect straight away to install docker
SLEEP=5
# create instance if directory doesn't exist
INSTANCE_DIR="ec2_instance-$MY_ROLE"

echo "create key pair"
# create public/private key pair without password
aws ec2 create-key-pair --key-name ${SECURITY_GROUP_NAME} --query 'KeyMaterial' --output text > ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem

echo "set permission on key pair"
# set correct permission on the private key
chmod 400 ${INSTANCE_DIR}/${SECURITY_GROUP_NAME}.pem

echo "fetch group id"
# fetch the group id of newly created group
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name ${SECURITY_GROUP_NAME} --description "security group for $MY_ROLE in EC2" --query "GroupId"  --output=text)

echo "group id to file"
# echo the security id to a file
echo ${SECURITY_GROUP_ID} > ${INSTANCE_DIR}/security-group-id.txt

# echo the name of the security_gropu to a file
echo "security group name to a file"
echo ${SECURITY_GROUP_NAME} > ${INSTANCE_DIR}/security-group-name.txt

echo "what is my address"
# get the address of my computer
MY_PUBLIC_IP=$(curl http://checkip.amazonaws.com)

echo "what is my cidr"
# add 32 bit mask to my address, making it a legal CIDR address
MY_CIDR=${MY_PUBLIC_IP}/32

echo "security group modify"
# allow incoming traffic on port 80, add rule to security group, I also want to be able to connect to port 22
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr 0.0.0.0/0 
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${MY_CIDR}
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr ${MY_CIDR}

# open for ssh
echo "open for ssh"
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 22 --cidr ${MY_CIDR}


