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
        sh 'npm install npm@latest -g'
        sh 'npm run-script build'
    }
}
