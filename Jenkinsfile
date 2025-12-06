pipeline {
    agent any

    environment {
        VENV_DIR = "venv"
        TEST_TYPE = "UI"    // UI / API / PERF / ALL
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Chrome + ChromeDriver') {
            steps {
                sh """
                apt-get update
                apt-get install -y wget unzip curl gnupg2

                echo "Installing Google Chrome..."
                wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                apt-get install -y ./google-chrome-stable_current_amd64.deb || apt --fix-broken install -y

                google-chrome --version

                echo "Installing matching ChromeDriver..."
                CHROME_VERSION=\$(google-chrome --version | sed 's/Google Chrome //g' | cut -d '.' -f 1-3)
                echo "Chrome version detected: \$CHROME_VERSION"

                CHROMEDRIVER_VERSION=\$(curl -s https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_\$CHROME_VERSION)
                echo "Using ChromeDriver version: \$CHROMEDRIVER_VERSION"

                wget -O chromedriver.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/\$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip
                unzip chromedriver.zip
                mv chromedriver-linux64/chromedriver /usr/bin/chromedriver
                chmod +x /usr/bin/chromedriver

                /usr/bin/chromedriver --version
                """
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                python3 -m venv ${VENV_DIR}
                . ${VENV_DIR}/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                """
            }
        }

        stage('Run UI Tests') {
            when {
                expression { env.TEST_TYPE == "UI" || env.TEST_TYPE == "ALL" }
            }
            steps {
                sh """
                . ${VENV_DIR}/bin/activate
                mkdir -p reports/ui
                robot -d reports/ui tests/ui
                """
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
        }
    }
}
