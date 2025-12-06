pipeline {
    agent {
        docker {
            image 'python:3.10'
            args '--shm-size=2g'
        }
    }

    environment {
        TEST_TYPE = "ALL"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Chrome & Dependencies') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y wget gnupg unzip curl libnss3 libxss1 libgconf-2-4 fonts-liberation libatk-bridge2.0-0 libgtk-3-0 libx11-xcb1

                    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
                    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
                        > /etc/apt/sources.list.d/google-chrome.list

                    apt-get update
                    apt-get install -y google-chrome-stable

                    google-chrome --version

                    # Install ChromeDriver matching Chrome version
                    CHROME_VER=$(google-chrome --version | awk '{print $3}' | cut -d'.' -f1)
                    wget -O /tmp/chromedriver.zip \
                        "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROME_VER.0.0/linux64/chromedriver-linux64.zip"

                    unzip /tmp/chromedriver.zip -d /usr/local/bin/
                    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/
                    chmod +x /usr/local/bin/chromedriver
                    chromedriver --version
                '''
            }
        }

        stage('Install Python Dependencies') {
            steps {
                sh """
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                """
            }
        }

        stage('Run UI & Unit Tests') {
            steps {
                echo "Running UI & Unit Tests..."
                sh """
                . venv/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot --variable HEADLESS:True tests/ui tests/unit || true
                """
            }
        }

        stage('Run API Tests') {
            steps {
                echo "Running API Tests..."
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/api || true
                """
            }
        }

        stage('Run Performance Tests') {
            steps {
                echo "Running Performance Tests..."
                sh """
                . venv/bin/activate
                robot -d reports/robot tests/perf || true
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Publishing Robot results..."
            robot outputPath: 'reports/robot'
        }
    }
}
