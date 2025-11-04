pipeline {
  agent any

  environment {
    IMAGE_NAME = "redis-producer"
    IMAGE_TAG = "v1"
  }

  stages {
    stage('Clone Repo') {
      steps {
        echo "📥 Cloning the GitHub repo..."
        // SCM clone is already handled
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "🔨 Building Docker image for ${IMAGE_NAME}..."
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
        sh 'kubectl apply -f k8s/ || true'  // Avoid fail if cluster auth fails
      }
    }

    stage('Verify Deployment') {
      steps {
        echo "🔎 Checking pod status..."
        sh 'kubectl get pods'
      }
    }
  }

  post {
    failure {
      echo '❌ Pipeline failed. Check the logs above.'
    }
  }
}

