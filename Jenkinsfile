pipeline {
    agent {
        docker {
            image 'python:3.10-slim'
            args '-u root'  // allows installing Linux packages
        }
    }

    stages {
        stage('Setup') {
            steps {
                sh '''
                apt-get update && apt-get install -y chromium chromium-driver
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh 'python run_tests.py'
            }
        }

        stage('Archive Reports') {
            steps {
                archiveArtifacts artifacts: 'results/*', fingerprint: true
            }
        }
    }
}
