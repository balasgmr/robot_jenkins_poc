pipeline {
    agent {
        docker {
            image 'python:3.11-slim'
            args '-u root' // run as root to allow package installs
        }
    }

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'BOTH'],
            description: 'Select which tests to run'
        )
    }

    environment {
        WORKSPACE = "${env.WORKSPACE}"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/balasgmr/robot_jenkins_poc.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv robotenv
                    . robotenv/bin/activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests
                    pip install k6  # optional: only if you want to run k6 locally
                    mkdir -p results k6_results
                '''
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    if (params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH') {
                        sh '''
                            . robotenv/bin/activate
                            robot -d results/ui tests/ui
                        '''
                    }

                    if (params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH') {
                        sh '''
                            . robotenv/bin/activate
                            robot -d results/api tests/api
                        '''
                    }
                }
            }
        }

        stage('Run k6 Performance Test') {
            when {
                expression { return params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh '''
                    # If you installed k6 in Python venv, run it directly
                    # Otherwise, you can run k6 via Docker if preferred
                    k6 run --out json=k6_results/perf.json tests/perf/load_test.js
                '''
            }
        }

        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'results/**/*.html', allowEmptyArchive: true
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
