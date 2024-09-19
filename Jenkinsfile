pipeline {
    environment {
        IMAGE_NAME ="alpinehelloworld"
        IMAGE_TAG ="latest"
        DOCKERHUB_USR = "younesabdh"
        DOCKERHUB_PSW = "@librahimi21015B"
        STAGING = "younesabdh-staging"
        PRODUCTION = "younesabdh-production"
    }
    agent none
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -t younesabdh/$IMAGE_NAME:$IMAGE_TAG .'
                }
            }
        }
        stage('Run container based on built image'){
            agent any
            steps {
                script{
                    sh '''
                        docker run --name $IMAGE_NAME -d -p 80:5000 -e PORT=5000 younesabdh/$IMAGE_NAME:$IMAGE_TAG
                        sleep 5
                    '''
                }
            }
        }
        stage('Test image') {
            agent any
            steps{
                script {
                    sh '''
                        curl http://172.17.0.1 | grep -q "Hello world!"
                    '''
                }
            }
        }
        stage('Clean container') {
            agent any
            steps{
                script {
                    sh '''
                        docker stop $IMAGE_NAME
                        docker rm $IMAGE_NAME
                    '''
                }
            }
        }
        stage('Push image staging and deploy it') {
            when{
                expression {GIT_BRANCH == 'origin/master'}
            }
            agent any
            steps{
                script {
                    sh '''
                        echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                        docker push younesabdh/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
    }
}