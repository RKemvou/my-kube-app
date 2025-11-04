pipeline {
    agent any

    environment {
        KUBECONFIG = "/home/jenkins/.kube/config"
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image for $IMAGE_NAME..."
                sh '''
                    eval $(minikube docker-env)
                    docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo "🔍 Listing Docker images to verify build..."
                sh '''
                    eval $(minikube docker-env)
                    docker images | grep $IMAGE_NAME
                '''
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo "🚀 Applying Kubernetes manifests from ./k8s/"
                sh 'kubectl apply -f k8s/'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔎 Checking Pods and Services in the cluster..."
                sh '''
                    echo "--- Pods ---"
                    kubectl get pods -o wide
                    echo "--- Services ---"
                    kubectl get svc
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs above.'
        }
    }
}

