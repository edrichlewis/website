pipeline {
    agent {
        label 'slave1'
    }

    environment {
        DOCKER_IMAGE = "edrichlewis/apache-image:${env.BUILD_ID}"
        DOCKERHUB_CREDENTIALS = credentials("b1912fc2-78d7-4649-a81f-d9c91f568cc7")
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
                    withCredentials([usernamePassword(credentialsId:"${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                        sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin $DOCKER_REGISTRY"
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    //docker.withRegistry('https://docker.io/', "${DOCKER_CREDENTIALS}") {
                    //withCredentials([usernamePassword(credentialsId: 'docker-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                      //  sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                     //   docker.image("${DOCKER_IMAGE}").push()
                      sh 'docker push docker.io/${DOCKER_IMAGE}'
                        
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
