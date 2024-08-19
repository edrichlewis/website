pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "edrichlewis/apache-image:${env.BUILD_ID}"
        DOCKER_CREDENTIALS = 'docker-credentials-id'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def branch = env.BRANCH_NAME ?: 'master'
                    echo "Checking out branch: ${branch}"
                    git branch: branch, credentialsId: 'GitHub', url: 'https://github.com/edrichlewis/website.git'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    whoami
                    docker.build("${DOCKER_IMAGE}", "-f Dockerfile .")
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
                    if (env.BRANCH_NAME == 'master') {
                        sh "docker run -d -p 82:80 ${DOCKER_IMAGE}"
                    } else if (env.BRANCH_NAME == 'develop') {
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
