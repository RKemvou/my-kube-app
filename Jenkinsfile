pipeline {
    agent any

    environment {
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
        DOCKERHUB_USERNAME = "your-dockerhub-username"
        DOCKERHUB_IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
        KUBE_NAMESPACE = "my-kube-namespace"
        SERVICE_URL = "http://192.168.49.2:30082"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "📦 Pushing image to DockerHub: ${DOCKERHUB_IMAGE}"
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        eval $(minikube -p minikube docker-env)
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_IMAGE}
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKERHUB_IMAGE}
                    '''
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo '🚀 Deploying Kubernetes resources...'
                sh '''
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/configmap.yaml -n ${KUBE_NAMESPACE}
                    kubectl apply -f k8s/redis-deployment.yaml -n ${KUBE_NAMESPACE}
                    kubectl apply -f k8s/redis-service.yaml -n ${KUBE_NAMESPACE}
                    kubectl apply -f k8s/deployment.yaml -n ${KUBE_NAMESPACE}
                    kubectl apply -f k8s/service.yaml -n ${KUBE_NAMESPACE}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '🔎 Verifying deployment...'
                sh '''
                    kubectl get pods -n ${KUBE_NAMESPACE} -o wide
                    kubectl get svc -n ${KUBE_NAMESPACE}
                '''
            }
        }

        stage('Run Smoke Test') {
            steps {
                echo '🧪 Running smoke test...'
                sh '''
                    echo "Waiting for service to be ready..."
                    sleep 10
                    echo "Testing endpoint: ${SERVICE_URL}"
                    for i in {1..5}; do
                        curl --fail ${SERVICE_URL} && exit 0 || echo "Retry #$i failed..."; sleep 5;
                    done
                    echo "❌ Smoke test failed after 5 attempts."
                    exit 1
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Jenkins pipeline failed. Check logs.'
        }
    }
}

