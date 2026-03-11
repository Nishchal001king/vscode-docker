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
                bat """
                    docker build -t %DOCKERHUB_REPO%:%IMAGE_TAG% .
                    docker tag %DOCKERHUB_REPO%:%IMAGE_TAG% %DOCKERHUB_REPO%:latest
                """
            }
        }

       stage('Test Image') {
    steps {
        bat """
            docker run -d --name vscode-test -p 8888:8888 nishchal007/vscode-server:%IMAGE_TAG%
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
                    docker push %DOCKERHUB_REPO%:%IMAGE_TAG%
                    docker push %DOCKERHUB_REPO%:latest
                """
            }
        }

        stage('Cleanup') {
            steps {
                bat """
                    docker rmi %DOCKERHUB_REPO%:%IMAGE_TAG% || exit 0
                    docker rmi %DOCKERHUB_REPO%:latest || exit 0
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