pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API'],
            description: 'Select which tests to run'
        )
    }

    environment {
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
            when {
                expression { params.TEST_TYPE == 'UI' }
            }
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
                expression { params.TEST_TYPE == 'API' }
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
            echo "Pipeline completed. Selected TEST_TYPE = ${params.TEST_TYPE}"
            robot outputPath: 'reports/robot'
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
