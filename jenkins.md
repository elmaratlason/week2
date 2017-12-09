# Week 2
[![Build Status](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop/badge/icon)](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop)


md with view protected[![Build Status](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop/badge/icon)](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop/)

md with view unprotected [![Build Status](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/buildStatus/icon?job=hgop)](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop/)

without view

protected[![Build Status](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop/badge/icon)](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop)
Unprotected
[![Build Status](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/buildStatus/icon?job=hgop)](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop)

## [Jenkins](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080)
## [The Game](http://ec2-54-76-136-201.eu-west-1.compute.amazonaws.com:8080)

### Scripts
#### Start by provisioning an ec2 instance.

Run [Provision ec2](provision_aws.sh) which creates a new ec2 instance in region eu-west-2 (london)

It creates a security group that opens for:
- GitHub addresses for hooks: (192.30.252.0/22, 185.199.108.0/22, 2620:112:3000::/44)
- my home address: 22 and 8080
- schools address (the address where I was located at time of running the script): 22 and 8080

After ec2 instance is up'n running [bootstrap-jenkins](bootstrap-jenkins.sh) script is called:

It connects to the new ec2 instance and runs [EC2 Bootstrap](ec2-bootstrap-jenkins.sh).

EC2-Bootstrap installs:
- Jenkins
- java 1.8
- docker
- docker-compose
- Git
- nodejs
- npm
- nvm
- yarn

### Manual work
__Inside Jenkins__
- Create a project (hgop) that pulls tictactoe code from GitHub
 - A hook is configured on github to notify jenkins which then pulls from repo.
 - Generated public/private keys on Jenkins and public key added to github to allow jenkins to connect to repo
 - enable security (/var/lib/jenkins/config.xml)
- Add Plugins:
 - GitHub Authentication
 - GitHub Integration
 - Gravatar
 - NodeJS
 - Pipeline

 ### Jenkinsfile
 The file that binds all the steps in the pipeline.

 [Jenkinsfile]()

 The stages are:
 - __Build__ - (install needed packages with yarn (or npm))
 - __Test__ - (run unit test on the tictactoe app)
 - __Project Build__ -(package the tictactoe app for deploy)
 - __Docker build__ - (create a docker image with new version of tictactoe)
 - __Deploy To AWS__ - (deploy tictactoe to ec2 instance )

Prior to running those stages, we run: "_checkout scm_" which checks out newest version of the code, using pipeline plugin in jenkins.

Some stages could maybe be joined, but that would not make this any clearer.

### Jenkins credentials for external services (dockerhub / aws)

This needs to be done manually, which can be done by connecting to Jenkins ec2 instance with ssh (use script: aws.sh)
- run bash as jenkins: sudo su -s /bin/bash jenkins
 - run: docker login
   - this creates credentials file under /var/lib/jenkins/.docker/config.json
- run: "aws configure"

## More
[Version info](http://ec2-54-76-136-201.eu-west-1.compute.amazonaws.com:8080/version.html)

- [dockerbuild.sh]()
 - builds docker image after application is built and pushes it to dockerhub
- [docker-compose.yml](provisioning/docker-compose.yml)
 - add postgres port 5432:5432
- [server/database.json](database.json)
 - change from localhost -> postgres

# Author
[Elmar Atlason](mailto:elmar.atlason@gmail.com)

elmar14@ru.is
