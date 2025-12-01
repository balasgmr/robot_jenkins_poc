pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API'],
            description: 'Choose test suite to run'
        )
    }

    environment {
        ROBOT_REPORT_DIR = "reports/robot"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                """
            }
        }

        stage('Install Chrome & ChromeDriver') {
            when { expression { params.TEST_TYPE == 'UI' } }
            steps {
                sh """
                    # Install Chrome
                    apt-get update
                    apt-get install -y wget gnupg unzip
                    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
                    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
                    apt-get update
                    apt-get install -y google-chrome-stable

                    # Verify Chrome installation
                    google-chrome --version
                """
            }
        }

        stage('Run UI Tests') {
            when { expression { params.TEST_TYPE == 'UI' } }
            steps {
                echo "Running UI Tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    . venv/bin/activate
                    # Retry once in case of intermittent Chrome failure
                    for i in 1 2; do
                        robot -d ${ROBOT_REPORT_DIR} tests/ui && break || sleep 5
                    done
                """
            }
            post {
                always {
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }

        stage('Run API Tests') {
            when { expression { params.TEST_TYPE == 'API' } }
            steps {
                echo "Running API Tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    . venv/bin/activate
                    robot -d ${ROBOT_REPORT_DIR} tests/api
                """
            }
            post {
                always {
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${params.TEST_TYPE}"
        }
    }
}
