pipeline {
    agent any
    environment {
        IMAGE_NAME = 'redis-producer'
        IMAGE_TAG = 'v1'
        DOCKERHUB_REPO = "kemvouachille/${IMAGE_NAME}:${IMAGE_TAG}"
        KUBE_NAMESPACE = 'my-kube-namespace'
        KUBECONFIG = "${env.HOME}/.kube/config"
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
                echo "📤 Pushing image to DockerHub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        eval $(minikube -p minikube docker-env)
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} $DOCKER_USER/${IMAGE_NAME}:${IMAGE_TAG}
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_USER/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo "🚀 Deploying to Minikube..."
                sh '''
                    kubectl apply -n ${KUBE_NAMESPACE} -f k8s/
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔎 Verifying Kubernetes deployment..."
                sh '''
                    kubectl get pods -n ${KUBE_NAMESPACE} -o wide
                    kubectl get svc -n ${KUBE_NAMESPACE}
                '''
            }
        }

        stage('Run Smoke Test') {
            steps {
                echo "🧪 Running smoke test on deployed service..."
                sh './test.sh'
            }
        }
    }

    post {
        success {
            echo '✅ Jenkins pipeline completed successfully.'
        }
        failure {
            echo '❌ Jenkins pipeline failed. Please review the logs above.'
        }
    }
}

