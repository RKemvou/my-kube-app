pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'kemvouachille'
        IMAGE_NAME = 'redis-producer'
        IMAGE_TAG = 'v1'
        FULL_IMAGE_NAME = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
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
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        eval $(minikube -p minikube docker-env)
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${FULL_IMAGE_NAME}
                    '''
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo '🚀 Deploying to Kubernetes...'
                sh '''
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/configmap.yaml -n my-kube-namespace
                    kubectl apply -f k8s/redis-deployment.yaml -n my-kube-namespace
                    kubectl apply -f k8s/redis-service.yaml -n my-kube-namespace
                    kubectl apply -f k8s/deployment.yaml -n my-kube-namespace
                    kubectl apply -f k8s/service.yaml -n my-kube-namespace
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '🔎 Verifying Kubernetes deployment...'
                sh '''
                    kubectl get pods -n my-kube-namespace -o wide
                    kubectl get svc -n my-kube-namespace
                '''
            }
        }

        stage('Run Smoke Test') {
            steps {
                echo '🧪 Running smoke test...'
                sh './test.sh'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Jenkins pipeline failed. Please review the logs above.'
        }
    }
}

