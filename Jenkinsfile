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
                sh '''
                    # Install Python3 and pip if not installed
                    if ! command -v python3 >/dev/null; then
                        apt-get update && apt-get install -y python3 python3-venv python3-pip
                    fi

                    # Create virtual environment
                    python3 -m venv $VENV_DIR
                    . $VENV_DIR/bin/activate

                    # Upgrade pip and install Robot Framework dependencies
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests k6
                '''
            }
        }

        stage('Run Robot UI Tests') {
            when {
                expression { params.TEST_TYPE == 'UI' || params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh '''
                    . $VENV_DIR/bin/activate
                    mkdir -p results/ui
                    robot -d results/ui tests/ui
                '''
            }
        }

        stage('Run Robot API Tests') {
            when {
                expression { params.TEST_TYPE == 'API' || params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh '''
                    . $VENV_DIR/bin/activate
                    mkdir -p results/api
                    robot -d results/api tests/api
                '''
            }
        }

        stage('Run k6 Performance Test') {
            when {
                expression { params.TEST_TYPE == 'BOTH' }
            }
            steps {
                sh '''
                    mkdir -p k6_results
                    k6 run --out json=k6_results/perf.json tests/perf/load_test.js
                '''
            }
        }

        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'results/**/*.html', allowEmptyArchive: true
                archiveArtifacts artifacts: 'k6_results/*.json', allowEmptyArchive: true

                // Robot Framework reporting
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
