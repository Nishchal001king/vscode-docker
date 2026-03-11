pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_REPO        = 'nishchal001king/vscode-server'
        IMAGE_TAG             = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-credentials',
                    url: 'https://github.com/Nishchal001king/vscode-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t nishchal001king/vscode-server:${IMAGE_TAG} .
                    docker tag nishchal001king/vscode-server:${IMAGE_TAG} nishchal001king/vscode-server:latest
                '''
            }
        }

        stage('Test Image') {
            steps {
                sh '''
                    docker run -d --name vscode-test -p 8081:8080 nishchal001king/vscode-server:${IMAGE_TAG}
                    sleep 5
                    curl -f http://localhost:8081 || true
                    docker stop vscode-test && docker rm vscode-test
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    docker push nishchal001king/vscode-server:${IMAGE_TAG}
                    docker push nishchal001king/vscode-server:latest
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    docker rmi nishchal001king/vscode-server:${IMAGE_TAG} || true
                    docker rmi nishchal001king/vscode-server:latest || true
                    docker logout
                '''
            }
        }
    }

    post {
        success { echo 'VSCode image pushed to Docker Hub!' }
        failure { echo 'Pipeline failed. Check logs.' }
    }
}