pipeline {
    agent any

    environment {
        TEST_TYPE = "UI"
        VENV_PATH = "${WORKSPACE}/venv"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh """
                    python3 -m venv ${VENV_PATH}
                    . ${VENV_PATH}/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                """
            }
        }

        stage('Run UI Tests') {
            steps {
                sh """
                    . ${VENV_PATH}/bin/activate
                    mkdir -p reports/robot
                    robot -d reports/robot tests/ui
                """
            }
        }

        stage('Run API Tests') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                sh """
                    . ${VENV_PATH}/bin/activate
                    robot -d reports/robot tests/api
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${TEST_TYPE}"
            robot outputPath: 'reports/robot'
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
