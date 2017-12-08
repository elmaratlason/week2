# Week 2
## [Jenkins](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080)
## [TheGame](http://ec2-54-76-136-201.eu-west-1.compute.amazonaws.com:8080) -(url constantly changin when new version is deployed)
### Scripts
* Start by provisioning an ec2 instance.
run:

  [Provision ec2](provision_aws.sh)

  This script creates a new ec2 instance in region eu-west-2 (london)

  creates a security group that opens for:

  GitHub addresses for hooks: (192.30.252.0/22, 185.199.108.0/22, 2620:112:3000::/44)

  my home address for ssh and 8080

* After ec2 instance is up'n running
this script is called:

  [Bootstrap](bootstrap-jenkins.sh)

This script connects to the new instance and runs another script.

  [EC2 Bootstrap](ec2-bootstrap-jenkins.sh)

This script installs:
* Jenkins
* java 1.8
* docker
* docker-compose
* Git
* node
* nodejs
* npm
* nvm
# yarn

### Manual work
Inside Jenkins
- Create a project (hgop) that pulls tictactoe code from GitHub
 - A hook is configured on github to notify jenkins which then pulls from repo.
 - Generated public/private keys on Jenkins and public key added to github to allow jenkins to connect to repo
- Add Plugins:
 - GitHub Authentication
 - GitHub Integratin
 - Gravatar
 - NodeJS
 - Pipeline

### Jenkins credentials for external services (dockerhub / aws)

That can be done by connecting to Jenkins with ssh (use: ./aws.sh)
* run bash as jenkins: sudo su -s /bin/bash jenkins
* run: docker login
** this creates credentials file under /var/lib/jenkins/.docker/config.json
* run: aws configure

## More
dockerbuild.sh - builds docker image after application is built and pushes it to dockerhub
docker-compose.yml - add postgres port 5432:5432
server/database.json - change localhost -> postgres


# Author
[Elmar Atlason](mailto:elmar.atlason@gmail.com)

elmar14@ru.is

