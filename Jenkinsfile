node {
    checkout scm
    stage('Build') {
        echo 'Building in stage BUILD..'
        npm run startpostgres
        npm run startserver
    }
    stage('Test') {
        echo 'Testing..'
        npm run start
        npm run apitest
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}
