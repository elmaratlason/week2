node {
    checkout scm
    stage('Clean') {
        // Clean files from last build.
        sh 'git clean -dfxq'
    }

    stage('Setup') {
        // Prefer yarn over npm.
        sh 'yarn install || npm install'
        dir('client')
        {
            sh 'yarn install || npm install'
        }

/*    stage('Build') {
        echo 'Building in stage BUILD..'
        /*sh 'npm install'
        run with yarn instead of npm*/
        sh 'yarn install'
    }
*/

    stage('Test') {
        echo 'Testing..'
        sh 'npm run test:nowatch'
    }
/*
    stage('Load-test') {
        echo 'Testing..'
        sh 'npm run-script loadtest:nowatch'
    }
    */
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
