node {
    checkout scm

    stage('Build') {
        echo 'Building in stage BUILD..'
        echo 'run npm install..'
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
