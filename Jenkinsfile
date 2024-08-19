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
                    sh 'whoami'
                    docker.build("${DOCKER_IMAGE}", "-f Dockerfile .")
                }
            }
        }
        stage('Login to Docker Hub'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId:"${DOCKER_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin $DOCKER_REGISTRY"
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    //docker.withRegistry('https://docker.io/', "${DOCKER_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}").push()
                        
                   // }
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
