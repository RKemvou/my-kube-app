pipeline {
    agent any

    environment {
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
        KUBE_NAMESPACE = "my-kube-namespace"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image for ${IMAGE_NAME}:${IMAGE_TAG}..."
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo '🔍 Listing Docker images to verify build...'
                sh '''
                    eval $(minikube -p minikube docker-env)
                    docker images | grep ${IMAGE_NAME}
                '''
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo '🚀 Applying Kubernetes manifests from ./k8s/'
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
                echo '🔎 Verifying Kubernetes deployment...'
                sh '''
                    kubectl get pods -n ${KUBE_NAMESPACE} -o wide
                    kubectl get svc -n ${KUBE_NAMESPACE}
                '''
            }
        }

        stage('Run Smoke Test') {
            steps {
                echo '🧪 Running smoke test on deployed service...'
                sh './test.sh'
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline failed. Check the logs above.'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
    }
}

