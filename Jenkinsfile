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
        VENV_DIR = "${WORKSPACE}/robotenv"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/balasgmr/robot_jenkins_poc.git', branch: 'main'
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh """
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests
                """
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    if (params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH') {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            robot tests/ui
                        """
                    }

                    if (params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH') {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            robot tests/api
                        """
                    }
                }
            }
        }

        stage('Run k6 Performance Test') {
            when {
                expression { return params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh """
                    k6 run tests/perf/load_test.js
                """
            }
        }
    }

    post {
        always {
            echo "Build completed. UI, API, and k6 tests executed."
        }
    }
}
