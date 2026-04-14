pipeline {
    agent any

  environment {
    DOCKER_IMAGE = "madhuriajay/cloudapp:${BUILD_NUMBER}"
}

    stages {

        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/madhuriajay/cloudapp.git'
            }
        }

        stage('Build JAR using Docker Maven') {
            agent {
                docker {
                    image 'maven:3.9.9-eclipse-temurin-17'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Login Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-pass', variable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u madhuriajay --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker rm -f cloudapp-container || true
                docker run -d --name cloudapp-container -p 8080:8080 $DOCKER_IMAGE
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
    }
}
