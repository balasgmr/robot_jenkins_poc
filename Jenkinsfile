pipeline {
    agent none  // we'll define agent per stage

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'BOTH'],
            description: 'Select which tests to run'
        )
    }

    stages {

        stage('Checkout SCM') {
            agent any
            steps {
                git url: 'https://github.com/balasgmr/robot_jenkins_poc.git', branch: 'main'
            }
        }

        stage('Run Robot Tests') {
            agent {
                docker {
                    image 'python:3.11-slim'
                    args '-u root:root' // run as root to allow pip install
                }
            }
            steps {
                sh '''
                    python3 -m venv robotenv
                    . robotenv/bin/activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests
                    mkdir -p results
                '''

                script {
                    if (params.TEST_TYPE == 'UI') {
                        sh '. robotenv/bin/activate && robot -d results tests/ui'
                    } else if (params.TEST_TYPE == 'API') {
                        sh '. robotenv/bin/activate && robot -d results tests/api'
                    } else if (params.TEST_TYPE == 'BOTH') {
                        sh '. robotenv/bin/activate && robot -d results tests'
                    }
                }
            }
        }

        stage('Run k6 Performance Test') {
            agent {
                docker {
                    image 'loadimpact/k6:latest'
                }
            }
            when {
                expression { return params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh '''
                    mkdir -p k6_results
                    k6 run --out json=k6_results/perf.json tests/perf/load_test.js
                '''
            }
        }

        stage('Publish Reports') {
            agent any
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
