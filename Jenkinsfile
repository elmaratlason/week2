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
    stage('Deploy') {
        echo 'Deploying....'
    }
}
