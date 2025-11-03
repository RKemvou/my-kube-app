pipeline {
    agent { label 'master' }

    environment {
        // Path to your Minikube kubeconfig file
        KUBECONFIG = '/root/.kube/config'
    }

    stages {
        stage('Clone GitHub Repo') {
            steps {
                git 'https://github.com/RKemvou/my-kube-app.git'
            }
        }

        stage('Deploy to Minikube') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}

