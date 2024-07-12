pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'GitHub-Credentials' // pending
        SERVER_IP = '44.201.193.5' // public ec2 hosted ip
        SSH_CREDENTIALS_ID = 'ssh-ec2-keypair'
    }

    stages {
        stage('Checkout') {
            steps {
                git(credentialsId: env.GIT_CREDENTIALS_ID, url: 'https://github.com/UML-GUI-II-GROUP-1/student-swap.git')
            }
        }
        stage('Build Backend') {
            steps {
                dir('backend') {
                    sh './build.sh' // create one for frontend
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
                    sh './test.sh' // create one for backend
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
                    ssh -o StrictHostKeyChecking=no ec2-user@${SERVER_IP} 'bash -s' < deploy.sh
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
