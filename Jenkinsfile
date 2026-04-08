pipeline {
    agent any
    environment {
        CONF_PATH = "/home/ubuntu/data-store"
    }
    stages {
        stage('Deploy') {
            steps {
                sh 'mkdir src'
                script {
                    def containerName = "wp_docker"
                    def result = sh(
                        script: "docker ps -q -f name=^/${containerName}\$",
                        returnStdout: true
                    ).trim()
                    boolean isRunning = result.length() > 0
                    if (isRunning) {
                        echo "Container ${containerName} is currently running."
                        sh 'docker compose down'
                    } else {
                        echo "Container ${containerName} is NOT running."
                    }
                    sh 'docker compose up --build -d'
                }
                echo "docker container running......!"

            }
        }
    }
}