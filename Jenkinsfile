pipeline {
    agent any

    environment {
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
        DOCKERHUB_USER = "kemvouachille"
        DOCKER_USER = credentials('docker-credentials-username') // Add this credential in Jenkins
        DOCKER_PASS = credentials('docker-credentials-password') // Add this credential in Jenkins
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
                echo '🔍 Verifying Docker image exists...'
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker images | grep ${IMAGE_NAME}
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '📤 Pushing image to DockerHub...'
                withCredentials([
                    string(credentialsId: 'docker-credentials-username', variable: 'DOCKER_USER'),
                    string(credentialsId: 'docker-credentials-password', variable: 'DOCKER_PASS')
                ]) {
                    sh '''
                        eval $(minikube -p minikube docker-env)
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo '🚀 Deploying to Minikube...'
                sh '''
                    eval $(minikube -p minikube docker-env)
                    kubectl apply -f k8s/
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '✅ Verifying Kubernetes deployment...'
                sh '''
                    kubectl get pods
                    kubectl get svc
                '''
            }
        }
    }

    post {
        failure {
            echo '❌ Jenkins pipeline failed. Please review the logs above.'
        }
        success {
            echo '✅ Jenkins pipeline completed successfully!'
        }
    }
}

