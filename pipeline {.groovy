pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = '2fa054b3-af01-489d-81f9-d8db57ed6feb'  // ID de las credenciales 
    }

    stages {
        stage('Test Docker') {
            steps {
                script {
                    sh 'docker --version'
                }
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'jenkins', url: 'https://github.com/skynhero/cs_devops_examen.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Construir la imagen Docker
                    docker.build('skynhero/cs_devops_examen:latest')
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Iniciar sesión en Docker Hub usando las credenciales
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        // Subir la imagen al Docker Hub
                        docker.image('skynhero/cs_devops_examen:latest').push()
                    }
                }
            }
        }
    }
}
