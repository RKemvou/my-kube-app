pipeline {
    agent any

    environment {
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
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

        stage('Verify Docker Image') {
            steps {
                echo '🔍 Listing Docker images to confirm build...'
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker images | grep ${IMAGE_NAME}
                '''
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo '🚀 Deploying to Kubernetes via kubectl apply...'
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
                echo '🔎 Verifying pod and service status...'
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
                    echo "🔍 Waiting for service to become available..."
                    sleep 10
                    echo "🔗 Testing endpoint: ${SERVICE_URL}"
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
            echo '✅ Jenkins pipeline completed successfully!'
        }
        failure {
            echo '❌ Jenkins pipeline failed. Please review the logs above.'
        }
    }
}

