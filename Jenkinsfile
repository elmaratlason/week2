node {
    checkout scm
        stage('execute shell'){
        echo "not do stuff"
        /*
        I did manual login on docker hub with my account, the worker account was unable to push image
        sh 'mkdir .docker || echo ".docker directory exists"'
        sh 'cp ~/.docker/config.json ~/.docker/config.`date +%Y-%m-%d-%H-%M-%S`.json || echo "no config file to backup"'
        sh 'cat ~/.docker/config.json || echo "no docker config file"# before'
        sh 'docker login --username=elmarjenkinsworker --password=elmarjenkinsworker index.docker.io/v1'
        sh 'cat ~/.docker/config.json # after'
        */
    }
    stage('Build') {
        echo 'Building in stage BUILD..'
        sh 'npm install'
    }
    stage('Test') {
        echo 'Testing..'
        sh 'npm run test'
    }
    stage('Project Build') {
        echo 'Building Project'
        sh 'npm run-script build'
    }
    stage('Docker build'){
        echo 'Building docker image'
        sh './dockerbuild.sh'
        echo 'Pushed docker image to docker hub'
    }
    stage('Deploy to AWS'){
        echo 'deploy to aws'
        sh 'cd provisioning && ./provision-new-environment.sh'
    }
}
