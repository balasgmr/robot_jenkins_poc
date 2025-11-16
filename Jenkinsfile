pipeline {
    agent any

    environment {
        ROBOT_ENV = "robotenv"
        RESULTS_DIR = "results"
        K6_RESULTS_DIR = "k6_results"
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
                    # Install Python3 and pip if not already installed
                    apt-get update -y || true
                    apt-get install -y python3 python3-venv python3-pip || true

                    # Create virtual environment
                    python3 -m venv $ROBOT_ENV

                    # Activate and install Robot Framework & dependencies
                    . $ROBOT_ENV/bin/activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary selenium webdriver-manager robotframework-requests
                '''
            }
        }

        stage('Run Robot UI Tests') {
            steps {
                sh '''
                    . $ROBOT_ENV/bin/activate
                    mkdir -p $RESULTS_DIR
                    robot -d $RESULTS_DIR tests/ui
                '''
            }
        }

        stage('Run Robot API Tests') {
            steps {
                sh '''
                    . $ROBOT_ENV/bin/activate
                    mkdir -p $RESULTS_DIR
                    robot -d $RESULTS_DIR tests/api
                '''
            }
        }

        stage('Run k6 Performance Test') {
            steps {
                sh '''
                    # Make sure k6 is installed
                    if ! command -v k6 &> /dev/null
                    then
                        echo "Installing k6..."
                        apt-get install -y gnupg software-properties-common curl
                        curl -s https://dl.k6.io/key.gpg | apt-key add -
                        echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list
                        apt-get update
                        apt-get install -y k6
                    fi

                    mkdir -p $K6_RESULTS_DIR
                    k6 run -o json=$K6_RESULTS_DIR/results.json tests/perf/load_test.js
                '''
            }
        }
    }

    post {
        always {
            echo "Build completed. Check $RESULTS_DIR for Robot Framework results and $K6_RESULTS_DIR for performance test results."
        }
    }
}
