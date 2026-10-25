pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        SECRET_ARN = 'arn:aws:secretsmanager:ap-south-1:660083831844:secret:secure-secrets-deployment/app-V6872J'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    set +x
                    chmod +x scripts/validate.sh
                    ./scripts/validate.sh
                '''
            }
        }

        stage('Verify AWS Access') {
            steps {
                sh '''
                    set +x
                    chmod +x scripts/setup-aws.sh
                    ./scripts/setup-aws.sh
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set +x
                    docker build \
                      --tag secure-secrets-deployment:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
                    set +x
                    docker compose up -d --build
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                    set +x

                    for attempt in $(seq 1 12); do
                        if curl --fail --silent \
                            http://127.0.0.1:8081/health >/dev/null; then
                            echo "Health check passed."
                            exit 0
                        fi

                        sleep 5
                    done

                    echo "Health check failed."
                    exit 1
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished. Review the stage results.'
        }
    }
}
