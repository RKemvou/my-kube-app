pipeline {
    agent any

    environment {
        KUBECONFIG = "/home/jenkins/.kube/config"
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
        NAMESPACE = "my-kube-namespace"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image for ${IMAGE_NAME}:${IMAGE_TAG}..."
                sh 'eval $(minikube -p minikube docker-env) && docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo "🔍 Listing Docker images to verify build..."
                sh 'eval $(minikube -p minikube docker-env) && docker images | grep $IMAGE_NAME'
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo "🚀 Applying Kubernetes manifests from ./k8s/"
                sh '''
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/configmap.yaml -n $NAMESPACE
                    kubectl apply -f k8s/redis-deployment.yaml -n $NAMESPACE
                    kubectl apply -f k8s/redis-service.yaml -n $NAMESPACE
                    kubectl apply -f k8s/deployment.yaml -n $NAMESPACE
                    kubectl apply -f k8s/service.yaml -n $NAMESPACE
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Verifying resources in namespace $NAMESPACE"
                sh 'kubectl get all -n $NAMESPACE'
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

