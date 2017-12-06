#!/bin/bash
# 
# provision new ec2 instance for jenkins
# should accept argument for group name ( purpose ) ,like: ./create_ec2_stuff.sh jenkins
# 
# elmar.atlason@gmail.com / elmar14@ru.is
# Háskólinn í Reykjavík - 2017

# make it more general
if [ $# -eq 0 ]; then
  echo "No arguments provided"
  MY_ROLE=jenkins
else
  MY_ROLE=$1
fi

# SETTINGS
#GitHub addresses for hooks
GIT1=192.30.252.0/22
GIT2=185.199.108.0/22
GIT3=2620:112:3000::/44

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
if [ -d "${INSTANCE_DIR}" ]; then
    exit
fi

[ -d "${INSTANCE_DIR}" ] || mkdir ${INSTANCE_DIR}

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
if [ $PUBLIC_WEB_ACCESS ]
then
  echo "open for public web access"
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr 0.0.0.0/0
else
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${GIT1}
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${GIT2}
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${GIT3}
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${MY_CIDR}
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr ${MY_CIDR}
fi

# open for ssh
echo "open for ssh"
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 22 --cidr ${MY_CIDR}

# open for icmp from my address
aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol icmp --port -1 --cidr ${MY_CIDR}

# open for ssh from home
if [ ${MY_CIDR} != ${HOME_IP} ]
then
  echo "my home address is not my current CIDR, always open for home"
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr ${HOME_IP}
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr ${HOME_IP}
  aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 22 --cidr ${HOME_IP}
fi

echo "start instance ami-e7d6c983"
# start instance and get the instance ID
INSTANCE_ID=$(aws ec2 run-instances --user-data file://bootstrap-jenkins.sh --image-id $AMI_ID --security-group-ids ${SECURITY_GROUP_ID} --count 1 --instance-type t2.micro --key-name ${SECURITY_GROUP_NAME} --query 'Instances[0].InstanceId'  --output=text)

echo "name of instance"
# duh, echo the instance ID
echo ${INSTANCE_ID} > ${INSTANCE_DIR}/instance-id.txt

echo "wait for instance startup..."
aws ec2 wait --region $REGION instance-running --instance-ids ${INSTANCE_ID}

echo "get public name"
# get public name, reachable from public internet to a variable
export INSTANCE_PUBLIC_NAME=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[*].Instances[*].PublicDnsName" --output=text)

# put the public address in a file
echo "add public address to a file"
echo ${INSTANCE_PUBLIC_NAME} > ${INSTANCE_DIR}/instance-public-name.txt

# sleep for few seconds as we are not able to connect to instance straight away...
echo "wait $SLEEP seconds"
sleep $SLEEP

# check if instance is answering, ping until it responses (max 60)
PING_COUNT="0"
ping -c 1 ${INSTANCE_PUBLIC_NAME} > /dev/null
while [ $? != 0 ] && [ $PING_COUNT -lt 60 ]
do
  PING_COUNT=$[$PING_COUNT+1]
  sleep 1
  echo .
  ping -c 1 ${INSTANCE_PUBLIC_NAME} > /dev/null
done

aws ec2 associate-iam-instance-profile --instance-id $(cat ./ec2_instance-jenkins/instance-id.txt) --iam-instance-profile Name=CICDServer-Instance-Profile

# call jenkins install script
./bootstrap-jenkins.sh
echo "running: bootstrap-jenkins.sh"
