node {
    checkout scm
    stage('Build') {
        echo 'Building in stage BUILD..'
        npm run startpostgres
        npm install
        npm run startserver
    }
    stage('Test') {
        echo 'Testing..'
        npm run test
        npm run start
        npm run apitest
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}
