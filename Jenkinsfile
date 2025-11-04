pipeline {
    agent any

    environment {
        KUBECONFIG = "/home/jenkins/.kube/config"
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

        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods -o wide'
                sh 'kubectl get svc'
            }
        }
    }
}

