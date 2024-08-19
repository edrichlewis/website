pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "edrichlewis/apache-image:${env.BUILD_ID}"
        DOCKER_CREDENTIALS = 'docker-credentials-id'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out branch: ${env.BRANCH_NAME}"
                git branch: "${env.BRANCH_NAME}", credentialsId: 'GitHub', url: 'https://github.com/edrichlewis/website.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}", "-f DOCKERFILE .")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/repositories/edrichlewis', "${DOCKER_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    if (env.GIT_BRANCH == 'master') {
                        sh "docker run -d -p 82:80 ${DOCKER_IMAGE}"
                    } else if (env.GIT_BRANCH == 'develop') {
                        echo "Build completed. Not deploying."
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
