pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'PERFORMANCE'],
            description: 'Choose which test suite to run'
        )
    }

    environment {
        ROBOT_REPORT_DIR = "reports/robot"
        K6_REPORT_DIR    = "reports/k6"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                    python3 -m pip install --upgrade pip
                    pip install -r requirements.txt
                """
            }
        }

        /* -----------------------------------------
              UI TESTS
        ----------------------------------------- */
        stage('Run UI Tests') {
            when { expression { params.TEST_TYPE == "UI" } }
            steps {
                echo "Running UI Robot tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    robot -d ${ROBOT_REPORT_DIR} tests/ui
                """
            }
            post {
                always {
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }

        /* -----------------------------------------
              API TESTS
        ----------------------------------------- */
        stage('Run API Tests') {
            when { expression { params.TEST_TYPE == "API" } }
            steps {
                echo "Running API Robot tests..."
                sh """
                    mkdir -p ${ROBOT_REPORT_DIR}
                    robot -d ${ROBOT_REPORT_DIR} tests/api
                """
            }
            post {
                always {
                    robot outputPath: "${ROBOT_REPORT_DIR}"
                }
            }
        }

        /* -----------------------------------------
              PERFORMANCE (k6)
        ----------------------------------------- */
        stage('Run Performance Tests') {
            when { expression { params.TEST_TYPE == "PERFORMANCE" } }
            steps {
                echo "Running k6 load test..."
                sh """
                    mkdir -p ${K6_REPORT_DIR}
                    k6 run tests/perf/load_test.js --out json=${K6_REPORT_DIR}/k6.json
                """
            }
            post {
                always {
                    archiveArtifacts artifacts: "${K6_REPORT_DIR}/*.json"
                }
            }
        }

    }

    post {
        always {
            echo "Pipeline completed. Selected TEST_TYPE = ${params.TEST_TYPE}"
        }
    }
}
