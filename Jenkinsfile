pipeline {
    agent any

    stages {

        stage('Setup Python Environment') {
            steps {
                sh '''#!/bin/bash
                    . /opt/robot-env/bin/activate

                    pip install --upgrade pip

                    pip install robotframework \
                                robotframework-seleniumlibrary \
                                selenium \
                                webdriver-manager
                '''
            }
        }

        stage('Run Robot Tests') {
            steps {
                sh '''#!/bin/bash
                    . /opt/robot-env/bin/activate

                    mkdir -p results

                    export CHROME_BIN=/usr/bin/chromium
                    export CHROMEDRIVER=/usr/bin/chromedriver

                    robot -v BROWSER:headlesschrome -d results tests/
                '''
            }
        }

        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'results/*', fingerprint: true

                publishHTML([
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Framework Report',
                    allowMissing: false,
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ])
            }
        }
    }
}
