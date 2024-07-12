pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'GitHub-Credentials'
        SERVER_IP = '44.201.193.5' // Hosted Server on EC2 instance public IP
        SSH_CREDENTIALS_ID = 'ssh-ec2-keypair'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: env.GIT_CREDENTIALS_ID, url: 'https://github.com/UML-GUI-II-GROUP-1/student-swap.git'
            }
        }
        stage('Set Permissions') {
            steps {
                sh 'chmod +x backend/build.sh backend/test.sh backend/start_backend.sh deploy.sh'
            }
        }
        stage('Build Backend') {
            steps {
                dir('backend') {
                    sh './build.sh'
                }
            }
        }
        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }
        stage('Test Backend') {
            steps {
                dir('backend') {
                    sh './test.sh'
                }
            }
        }
        stage('Test Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm test'
                }
            }
        }
        stage('Deploy') {
            steps {
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh '''
                    scp -o StrictHostKeyChecking=no -r backend ec2-user@${SERVER_IP}:/home/ec2-user/
                    scp -o StrictHostKeyChecking=no -r frontend ec2-user@${SERVER_IP}:/home/ec2-user/
                    scp -o StrictHostKeyChecking=no deploy.sh ec2-user@${SERVER_IP}:/home/ec2-user/
                    ssh -o StrictHostKeyChecking=no ec2-user@${SERVER_IP} 'bash /home/ec2-user/deploy.sh'
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Build and deployment successful: ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
        }
        failure {
            echo "Build and deployment failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
        }
    }
}
