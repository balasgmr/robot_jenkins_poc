pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_TYPE',
            choices: ['UI', 'API', 'BOTH'],
            description: 'Select which tests to run'
        )
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/balasgmr/robot_jenkins_poc.git', branch: 'main'
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    if (params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH') {
                        sh '''
                        docker run --rm -v $WORKSPACE:/workspace -w /workspace python:3.11-slim bash -c "
                            python3 -m venv robotenv &&
                            . robotenv/bin/activate &&
                            pip install --upgrade pip &&
                            pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests &&
                            mkdir -p results &&
                            robot -d results/ui tests/ui
                        "
                        '''
                    }

                    if (params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH') {
                        sh '''
                        docker run --rm -v $WORKSPACE:/workspace -w /workspace python:3.11-slim bash -c "
                            python3 -m venv robotenv &&
                            . robotenv/bin/activate &&
                            pip install --upgrade pip &&
                            pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests &&
                            mkdir -p results &&
                            robot -d results/api tests/api
                        "
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
                mkdir -p k6_results
                docker run --rm -v $WORKSPACE:/workspace -w /workspace loadimpact/k6:latest \
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
