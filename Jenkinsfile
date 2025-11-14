pipeline {
    agent any

    stages {

        stage('Setup Python Venv') {
            steps {
                sh '''
                    python3 -m venv robotenv
                    . robotenv/bin/activate

                    pip install --upgrade pip
                    pip install robotframework
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    . robotenv/bin/activate
                    robot -d results tests/
                '''
            }
        }

        stage('Publish Reports') {
            steps {
                publishHTML([
                    allowMissing: false,
                    keepAll: true,
                    alwaysLinkToLastBuild: true,
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Report'
                ])
            }
        }
    }
}
