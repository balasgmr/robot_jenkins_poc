pipeline {
    agent any

    environment {
        PYTHON = "/usr/bin/python3"
    }

    stages {

        /* ------------------------------
           CHECKOUT CODE
        --------------------------------*/
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/balasgmr/robot_jenkins_poc.git'
            }
        }

        /* ------------------------------
           SETUP PYTHON + INSTALL ROBOT DEPS
        --------------------------------*/
        stage('Setup Python Environment') {
            steps {
                sh '''
                    python3 -m venv robotenv
                    . robotenv/bin/activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium \
                        webdriver-manager robotframework-requests
                '''
            }
        }

        /* ------------------------------
           RUN UI ROBOT TESTS
        --------------------------------*/
        stage('Run Robot UI Tests') {
            steps {
                script {
                    sh '''
                        . robotenv/bin/activate
                        robot -d results/ui tests/ui
                    '''
                }
            }
        }

        /* ------------------------------
           RUN API ROBOT TESTS
        --------------------------------*/
        stage('Run Robot API Tests') {
            steps {
                script {
                    sh '''
                        . robotenv/bin/activate
                        robot -d results/api tests/api
                    '''
                }
            }
        }

        /* ------------------------------
           RUN k6 PERFORMANCE TEST
        --------------------------------*/
        stage('Run k6 Performance Test') {
            steps {
                sh '''
                    mkdir -p k6_results

                    docker run --rm \
                        -v ${WORKSPACE}:/workspace \
                        -w /workspace \
                        grafana/k6:latest run \
                        --out json=k6_results/perf.json \
                        tests/perf/sample_performance.js
                '''
            }
        }

        /* ------------------------------
           PUBLISH RESULTS
        --------------------------------*/
        stage('Publish Results') {
            when {
                expression {
                    fileExists('results/ui') ||
                    fileExists('results/api') ||
                    fileExists('k6_results/perf.json')
                }
            }
            steps {
                echo "Publishing Robot Framework and K6 results..."

                publishHTML([
                    reportDir: 'results/ui',
                    reportFiles: 'report.html',
                    reportName: 'UI Test Report'
                ])

                publishHTML([
                    reportDir: 'results/api',
                    reportFiles: 'report.html',
                    reportName: 'API Test Report'
                ])
            }
        }
    }

    post {
        always {
            echo "Build completed. Check results/ui, results/api, and k6_results folders."

            archiveArtifacts artifacts: 'results/**/*.*', allowEmptyArchive: true
            archiveArtifacts artifacts: 'k6_results/*', allowEmptyArchive: true
        }
    }
}
