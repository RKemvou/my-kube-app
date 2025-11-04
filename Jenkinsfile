pipeline {
    agent any

    environment {
        // Minikube Docker env
        DOCKER_TLS_VERIFY = "1"
        DOCKER_HOST = "tcp://192.168.49.2:2376"
        DOCKER_CERT_PATH = "/home/jenkins/.minikube/certs"
        MINIKUBE_ACTIVE_DOCKERD = "minikube"

        // Kubernetes config
        KUBECONFIG = "/home/jenkins/.kube/config"

        // Image tag
        DOCKER_IMAGE = "redis-producer:v1"
    }

    stages {
        stage('Clone Repo') {
            steps {
                echo "📥 Cloning GitHub repo..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image..."
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo "🔍 Listing Docker images..."
                sh 'docker images | grep redis-producer'
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo "🚀 Deploying to Minikube..."
                sh 'kubectl apply -f k8s/ --validate=false'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔎 Verifying Kubernetes resources..."
                sh 'kubectl get all -n default'
            }
        }
    }

    post {
        success {
            echo '✅ SUCCESS: Build and deployment complete!'
        }
        failure {
            echo '❌ FAILURE: Something went wrong. Check logs.'
        }
    }
}

