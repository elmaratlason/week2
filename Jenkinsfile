node {
    checkout scm
        stage('execute shell'){
        sh 'cp ~/.docker/config.json ~/.docker/config.`date +%Y-%m-%d-%H-%M-%S`.json || echo "no config file to backup"'
        sh 'cat ~/.docker/config.json # before'
        sh 'docker login --username=elmarjenkinsworker --password=elmarjenkinsworker hub.docker.net'
        sh 'cat ~/.docker/config.json # after'
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
    }
}
