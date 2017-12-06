#!/bin/bash
# test the setup

echo "http://$(cat ec2_instance-jenkins/instance-public-name.txt):8080"
curl http://$(cat ec2_instance-jenkins/instance-public-name.txt):8080
echo $?
