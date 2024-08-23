// pipeline {
//     agent {
//         label 'slave1'
//     }

//     environment {
//         DOCKER_IMAGE = "edrichlewis/apache-image:${env.BUILD_ID}"
//         DOCKERHUB_CREDENTIALS = credentials("b1912fc2-78d7-4649-a81f-d9c91f568cc7")
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 script {
//                     def branch = env.BRANCH_NAME ?: 'master'
//                     echo "Checking out branch: ${branch}"
//                     git branch: branch, credentialsId: 'GitHub', url: 'https://github.com/edrichlewis/website.git'
//                 }
//             }
//         }
//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     sh 'whoami'
//                     docker.build("${DOCKER_IMAGE}", "-f Dockerfile .")
//                 }
//             }
//         }
//         stage('Login to Docker Hub'){
//             steps{
//                 script{
//                     withCredentials([usernamePassword(credentialsId:"${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
//                         sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin $DOCKER_REGISTRY"
//                     }
//                 }
//             }
//         }
//         stage('Push Docker Image') {
//             steps {
//                 script {
//                     //docker.withRegistry('https://docker.io/', "${DOCKER_CREDENTIALS}") {
//                     //withCredentials([usernamePassword(credentialsId: 'docker-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
//                       //  sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
//                      //   docker.image("${DOCKER_IMAGE}").push()
//                       sh 'docker push docker.io/${DOCKER_IMAGE}'
                        
//                    // }
//                 }
//             }
//         }
//         stage('Deploy') {
//             steps {
//                 script {
//                     if (env.BRANCH_NAME == 'master') {
//                         sh "docker run -d -p 82:80 ${DOCKER_IMAGE}"
//                     } else if (env.BRANCH_NAME == 'develop') {
//                         echo "Build completed. Not deploying."
//                     }
//                 }
//             }
//         }
//     }

//     post {
//         success {
//             echo 'Pipeline completed successfully'
//         }
//         failure {
//             echo 'Pipeline failed'
//         }
//     }
// }
pipeline {
    agent none
    environment {
        DOCKERHUB_CREDENTIALS = credentials("76607488-2619-4d99-a175-1ab9a1cd2721")
    }
    stages {
        stage('git') {
            agent {
                label "slave1"
            }
            steps {
                script {
                    git'https://github.com/edrichlewis/website.git'
                }
            }
        }
        stage('docker') {
            agent {
                label "slave1"
            }
            steps {
                script {
                    sh 'sudo docker build . -t edrichlewis/proj2'
                    sh 'sudo docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}'
                    sh 'sudo docker push edrichlewis/proj2'
                }
            }
        }
        stage('kubernetes') {
            agent {
                label "slave1"
            }
            steps {
                script {
                     if (env.BRANCH_NAME == 'master') {
                        // sh "docker rm -f c1"
                        sh "docker run -d --name c1 -p 82:80 edrichlewis/proj2"
                    } else if (env.BRANCH_NAME == 'develop') {
                        echo "Build completed. Not deploying."
                }
            }
        }
    }
}
}
