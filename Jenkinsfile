pipeline {
    agent any

    environment {
        IMAGE_NAME = 'redis-producer'
        IMAGE_TAG = 'v1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '🔄 Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo "🔍 Verifying Docker image exists..."
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker images | grep ${IMAGE_NAME}
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '📤 Pushing image to DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        eval $(minikube -p minikube docker-env)
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo '🚀 Deploying to Minikube...'
                sh '''
                    eval $(minikube -p minikube docker-env)
                    kubectl apply -f deployment.yaml
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '🔍 Verifying deployment...'
                sh '''
                    kubectl get pods
                '''
            }
        }
    }

    post {
        failure {
            echo '❌ Jenkins pipeline failed. Please review the logs above.'
        }
    }
}

