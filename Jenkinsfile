pipeline {
    agent any

    stages {

        stage('Setup Environment') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y chromium chromium-driver python3-venv

                    python3 -m venv robotenv

                    . robotenv/bin/activate && \
                    pip install --upgrade pip --break-system-packages && \
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager --break-system-packages
                '''
            }
        }

        stage('Run Headless UI Tests') {
            steps {
                sh '''
                    . robotenv/bin/activate

                    mkdir -p results

                    export BROWSER=chromium
                    export WDM_LOG=0
                    export WDM_PRINT_FIRST_LINE=0

                    robot -d results tests/
                '''
            }
        }

        stage('Publish Report') {
            steps {
                publishHTML([
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Report',
                    allowMissing: false,
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ])
            }
        }
    }
}
