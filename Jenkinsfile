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
                echo "🔥 Building Docker image..."
                sh '''
                    eval $(minikube docker-env)
                    docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo "📦 Verifying Docker image..."
                sh '''
                    eval $(minikube docker-env)
                    docker images | grep $IMAGE_NAME
                '''
            }
        }

        stage('Apply Kubernetes YAMLs') {
            steps {
                echo "🚀 Deploying to Minikube..."
                sh 'kubectl apply -f k8s/'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Checking Kubernetes resources..."
                sh '''
                    kubectl get pods -o wide
                    kubectl get svc
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Something went wrong!'
        }
    }
}

