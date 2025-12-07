pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'BOTH'],
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
                expression { params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh """
                    . ${VENV_PATH}/bin/activate
                    mkdir -p reports/robot/ui
                    robot -d reports/robot/ui tests/ui
                """
            }
        }

        stage('Run API Tests') {
            when {
                expression { params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh """
                    . ${VENV_PATH}/bin/activate
                    mkdir -p reports/robot/api
                    robot -d reports/robot/api tests/api
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${params.TEST_TYPE}"
            
            // Publish UI results if exist
            script {
                if (fileExists('reports/robot/ui/output.xml')) {
                    robot outputPath: 'reports/robot/ui'
                }
                if (fileExists('reports/robot/api/output.xml')) {
                    robot outputPath: 'reports/robot/api'
                }
            }
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
