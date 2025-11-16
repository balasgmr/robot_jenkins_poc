pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'BOTH', 'PERF'],
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
                    pip install --upgrade pip --break-system-packages
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests --break-system-packages
                """
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    if (params.TEST_TYPE == 'UI') {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            mkdir -p results
                            robot -d results tests/ui
                        """
                    } else if (params.TEST_TYPE == 'API') {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            mkdir -p results
                            robot -d results tests/api
                        """
                    } else if (params.TEST_TYPE == 'BOTH') {
                        sh """
                            . ${VENV_DIR}/bin/activate
                            mkdir -p results
                            robot -d results tests
                        """
                    }
                }
            }
        }

        stage('Run k6 Performance Test') {
            when {
                expression { return params.TEST_TYPE == 'PERF' || params.TEST_TYPE == 'BOTH' }
            }
            steps {
                // Install k6 if not already installed
                sh 'which k6 || sudo apt-get update && sudo apt-get install -y k6'

                // Run the k6 script
                sh """
                    mkdir -p k6_results
                    k6 run --out json=k6_results/perf.json tests/perf/load_test.js
                """
            }
        }

        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'results/*.html', allowEmptyArchive: true
                archiveArtifacts artifacts: 'k6_results/*.json', allowEmptyArchive: true

                robot outputPath: 'results',
                      outputFileName: 'output.xml',
                      logFileName: 'log.html',
                      reportFileName: 'report.html',
                      passThreshold: 100,
                      unstableThreshold: 80
            }
        }
    }

    post {
        always {
            echo "Build completed. Check results/ folder, Jenkins Robot report, and k6_results/ folder."
        }
    }
}
