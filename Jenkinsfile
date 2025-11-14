pipeline {
    agent any

    stages {

        stage('Setup Python Environment') {
            steps {
                sh '''
                    # Activate virtual environment
                    source /opt/robot-env/bin/activate

                    # Upgrade pip inside venv
                    pip install --upgrade pip

                    # Install Robot Framework dependencies
                    pip install robotframework \
                                robotframework-seleniumlibrary \
                                selenium \
                                webdriver-manager
                '''
            }
        }

        stage('Run Robot Tests') {
            steps {
                sh '''
                    source /opt/robot-env/bin/activate
                    
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
