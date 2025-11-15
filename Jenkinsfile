pipeline {
    agent any

    environment {
        BROWSER = 'chromium'
        WDM_LOG = '0'
        WDM_PRINT_FIRST_LINE = '0'
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/balasgmr/robot_jenkins_poc.git'
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''
                    # Create a Python virtual environment
                    python3 -m venv robotenv

                    # Activate virtual environment and install Python packages
                    . robotenv/bin/activate && \
                    pip install --upgrade pip --break-system-packages && \
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager --break-system-packages
                '''
            }
        }

        stage('Run Headless UI Tests') {
            steps {
                sh '''
                    # Activate virtual environment
                    . robotenv/bin/activate

                    # Create results folder
                    mkdir -p results

                    # Run Robot Framework tests headlessly
                    robot -d results tests/
                '''
            }
        }

        stage('Publish Report') {
            steps {
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

    post {
        always {
            echo "Pipeline finished. Check Robot Framework report in the Build page."
        }
    }
}
