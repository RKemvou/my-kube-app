pipeline {
    agent any

    environment {
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
        KUBE_NAMESPACE = "my-kube-namespace"
    }

    stages {

        // -----------------------------
        // Stage 1: Build Docker Image
        // -----------------------------
        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        // -----------------------------
        // Stage 2: Verify Docker Image
        // -----------------------------
        stage('Verify Docker Image') {
            steps {
                echo '🔍 Listing Docker images to confirm build...'
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker images | grep ${IMAGE_NAME}
                '''
            }
        }

        // -----------------------------
        // Stage 3: Deploy to Minikube
        // -----------------------------
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

        // -----------------------------
        // Stage 4: Verify Deployment
        // -----------------------------
        stage('Verify Deployment') {
            steps {
                echo '🔎 Verifying pod and service status...'
                sh '''
                    kubectl get pods -n ${KUBE_NAMESPACE} -o wide
                    kubectl get svc -n ${KUBE_NAMESPACE}
                '''
            }
        }

        // -----------------------------
        // Stage 5: Smoke Test
        // -----------------------------
        stage('Run Smoke Test') {
            steps {
                echo '🧪 Running smoke test...'
                sh './test.sh'
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

