pipeline {
    agent {
        docker {
            image 'python:3.10'
            args '--shm-size=2g'
        }
    }

    environment {
        TEST_TYPE = "UI"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Chrome') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y wget gnupg unzip

                    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
                    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
                        > /etc/apt/sources.list.d/google-chrome.list

                    apt-get update
                    apt-get install -y google-chrome-stable

                    google-chrome --version
                '''
            }
        }

        stage('Install ChromeDriver') {
            steps {
                sh '''
                    CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d'.' -f1)
                    echo "Detected Chrome major version: $CHROME_VERSION"

                    wget -O /tmp/chromedriver.zip \
                        "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION.0.0/linux64/chromedriver-linux64.zip"

                    unzip /tmp/chromedriver.zip -d /usr/local/bin/
                    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/
                    chmod +x /usr/local/bin/chromedriver

                    chromedriver --version
                '''
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

        stage('Run UI Tests') {
            when { expression { env.TEST_TYPE == "UI" } }
            steps {
                echo "Running UI Tests..."
                sh """
                . venv/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot --variable HEADLESS:True tests/ui
                """
            }
        }

        stage('Run API Tests') {
            when { expression { env.TEST_TYPE == "API" } }
            steps {
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/api
                """
            }
        }

        stage('Run Performance Tests') {
            when { expression { env.TEST_TYPE == "PERF" } }
            steps {
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/perf
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"
            robot outputPath: 'reports/robot'
        }
    }
}
