pipeline {
    agent any

    environment {
        KUBECONFIG = "/home/jenkins/.kube/config"
        IMAGE_NAME = "redis-producer"
        IMAGE_TAG = "v1"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/RKemvou/my-kube-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image for producer..."
                sh 'eval $(minikube docker-env) && docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo "Listing images to verify build"
                sh 'eval $(minikube docker-env) && docker images'
            }
        }

        stage('Apply Kubernetes YAMLs') {
            steps {
                echo "Deploying to Minikube..."
                sh 'kubectl apply -f k8s/'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Pods:"
                sh 'kubectl get pods -o wide'
                echo "Services:"
                sh 'kubectl get svc'
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

