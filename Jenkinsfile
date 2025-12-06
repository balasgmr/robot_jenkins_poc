pipeline {
    agent any

    environment {
        TEST_TYPE = "UI"
        DISPLAY = ":99"
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
                # Start virtual display
                Xvfb :99 -screen 0 1920x1080x24 &
                export DISPLAY=:99

                . venv/bin/activate
                mkdir -p reports/robot
                # Run all UI tests
                robot -d reports/robot tests/ui
                '''
            }
        }

        stage('Run API Tests') {
            when {
                expression { return true }  // set to false to skip
            }
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
            when {
                expression { return true }  // set to false to skip
            }
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
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"
            # Publish Robot results
            robot outputPath: 'reports/robot'
        }
    }
}
