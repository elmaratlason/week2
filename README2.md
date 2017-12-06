# Day8

- Setting up Jenkins
 - installed on ec2 that was provisioned with week2/provision_aws.sh
 - [Jenkins](http://ec2-35-177-96-250.eu-west-2.compute.amazonaws.com:8080/job/hgop/11/console)
- Create a project that pulls their tic tac toe code from GitHub
 - project hgop created, a hook is configured on github to notify jenkins which then pulls from repo.
- Create a build step in Jenkins that runs tests, builds the code, builds a docker image and pushes to Docker Hub
 - Run Tests
 - Build app
 - Build Docker
 - Archive .env
 - Push docker image with Git Commit as Tag

    Create a deploy script that provisions a aws instance, if it doesn't already exist, and deploys with docker-compose the latest version
    Use Git Commit Tag to identify the correct image to pull with docker-compose
    When the pipeline is ready start TTD


Build

    Run tests
    Build app
    Build Docker
    Archive .env
    Push docker image with Git Commit as Tag

Deploy