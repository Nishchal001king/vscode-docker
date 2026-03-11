pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_REPO        = 'nishchal007/vscode-server'
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
                bat """
                    docker build -t nishchal007/vscode-server:%IMAGE_TAG% .
                    docker tag nishchal007/vscode-server:%IMAGE_TAG% nishchal007/vscode-server:latest
                """
            }
        }

        stage('Test Image') {
            steps {
                bat """
                    docker run -d --name vscode-test -p 8081:8080 nishchal007/vscode-server:%IMAGE_TAG%
                    ping -n 10 127.0.0.1 > nul
                    docker stop vscode-test
                    docker rm vscode-test
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                bat """
                    echo %DOCKERHUB_CREDENTIALS_PSW%| docker login -u %DOCKERHUB_CREDENTIALS_USR% --password-stdin
                    docker push nishchal007/vscode-server:%IMAGE_TAG%
                    docker push nishchal007/vscode-server:latest
                """
            }
        }

        stage('Cleanup') {
            steps {
                bat """
                    docker rmi nishchal007/vscode-server:%IMAGE_TAG% || exit 0
                    docker rmi nishchal007/vscode-server:latest || exit 0
                    docker logout
                """
            }
        }
    }

    post {
        success { echo 'VSCode image pushed to Docker Hub!' }
        failure { echo 'Pipeline failed. Check logs.' }
    }
}