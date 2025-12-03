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

        stage('Install Chrome & Chromedriver') {
            when { expression { params.TEST_TYPE == 'UI' } }
            steps {
                sh '''
                    echo "Installing Chrome & Chromedriver as root..."
                    su root -c "apt-get update"
                    su root -c "apt-get install -y wget unzip gnupg2"
                    su root -c "wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -"
                    su root -c "sh -c 'echo \\"deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main\\" >> /etc/apt/sources.list.d/google-chrome.list'"
                    su root -c "apt-get update"
                    su root -c "apt-get install -y google-chrome-stable"

                    # Install matching ChromeDriver
                    CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d. -f1)
                    DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}")

                    wget https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip
                    unzip chromedriver_linux64.zip
                    su root -c "mv chromedriver /usr/local/bin/"
                    chmod +x /usr/local/bin/chromedriver
                '''
            }
        }

        stage('Run UI Tests') {
            when { expression { params.TEST_TYPE == 'UI' } }
            steps {
                sh '''
                    mkdir -p reports/robot
                    . venv/bin/activate

                    export ROBOT_OPTIONS="--variable BROWSER_ARGS:--no-sandbox --variable BROWSER_ARGS:--disable-dev-shm-usage --variable BROWSER_ARGS:--headless=new"

                    robot -d reports/robot tests/ui
                '''
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
                sh '''
                    mkdir -p reports/robot
                    . venv/bin/activate
                    robot -d reports/robot tests/api
                '''
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
            echo "Pipeline completed. Se
