#!/bin/bash
# test the setup of jenkins server
# Háskólinn í Reykjavík - 2017
# elmar.atlason@gmail.com / elmar14@ru.is

echo "http://$(cat ec2_instance-jenkins/instance-public-name.txt):8080"
curl http://$(cat ec2_instance-jenkins/instance-public-name.txt):8080
echo $?
