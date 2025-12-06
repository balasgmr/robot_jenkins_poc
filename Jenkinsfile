pipeline {
    agent {
        docker {
            image 'python:3.11-slim'
            args '--shm-size=2g'  // Chrome needs more shared memory
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

        stage('Install Dependencies') {
            steps {
                sh '''
                apt-get update && apt-get install -y \
                    wget unzip curl gnupg \
                    fonts-liberation libnss3 libgconf-2-4 libx11-xcb1 libxcomposite1 libxcursor1 \
                    libxdamage1 libxi6 libxtst6 libatk1.0-0 libcups2 libxrandr2 libasound2 libpangocairo-1.0-0 \
                    libatk-bridge2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss1 libglib2.0-0

                # Install Chrome
                wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
                echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
                apt-get update && apt-get install -y google-chrome-stable

                # Install matching ChromeDriver
                CHROME_VERSION=$(google-chrome --version | grep -oP '\\d+\\.\\d+\\.\\d+')
                LATEST_DRIVER=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
                wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$LATEST_DRIVER/chromedriver_linux64.zip"
                unzip /tmp/chromedriver.zip -d /usr/local/bin/
                chmod +x /usr/local/bin/chromedriver

                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run UI Tests') {
            steps {
                echo "Running UI Tests..."
                sh '''
                . venv/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot tests/ui
                '''
            }
        }

        stage('Run API Tests') {
            steps {
                echo "Running API Tests..."
                sh '''
                . venv/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot tests/api
                '''
            }
        }

        stage('Run Performance Tests') {
            steps {
                echo "Running Performance Tests..."
                sh '''
                . venv/bin/activate
                mkdir -p reports/robot
                robot -d reports/robot tests/performance
                '''
            }
        }
    }

    post {
        always {
            echo "Publishing Robot Framework results..."
            robot outputPath: 'reports/robot'
        }
    }
}
