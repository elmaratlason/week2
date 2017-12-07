node {
    checkout scm
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
