pipeline {
    environment {

        IMAGE_NAME = "${PARAM_IMAGE_NAME}"                    /*alpinehelloworld par exemple*/
        APP_NAME = "${PARAM_APP_NAME}"                        /*eazytraining par exemple*/
        IMAGE_TAG = "${PARAM_IMAGE_TAG}"                      /*tag docker, par exemple latest*/
        
        STAGING = "${PARAM_APP_NAME}-staging"
        PRODUCTION = "${PARAM_APP_NAME}-prod"
        DOCKERHUB_USR = "${PARAM_DOCKERHUB_ID}"
        DOCKERHUB_PSW = credentials('dockerhub')
        APP_EXPOSED_PORT = "${PARAM_PORT_EXPOSED}"            /*80 par défaut*/

        STG_API_ENDPOINT = "172.28.128.140:1993"
        STG_APP_ENDPOINT = "172.28.128.140:80"
        PROD_API_ENDPOINT = "172.28.128.140:1993"
        PROD_APP_ENDPOINT = "172.28.128.140:80"
        
        INTERNAL_PORT = "${PARAM_INTERNAL_PORT}"              /*5000 par défaut*/
        EXTERNAL_PORT = "${PARAM_PORT_EXPOSED}"
        CONTAINER_IMAGE = "${DOCKERHUB_USR}/${IMAGE_NAME}:${IMAGE_TAG}"
    }
    agent none
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -t ${DOCKERHUB_USR}/$IMAGE_NAME:$IMAGE_TAG .'
                }
            }
        }
        stage('Run container based on built image'){
            agent any
            steps {
                script{
                    sh '''
                        echo "Cleaning existing container if exists"
                        docker ps -a | grep -i $IMAGE_NAME && docker rm -f $IMAGE_NAME
                        docker run --name $IMAGE_NAME -d -p $APP_EXPOSED_PORT:$INTERNAL_PORT -e PORT=$INTERNAL_PORT ${DOCKERHUB_USR}/$IMAGE_NAME:$IMAGE_TAG
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
                        curl http://172.17.0.1:$APP_EXPOSED_PORT | grep -q "Hello world!"
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
        stage('Login and Push Image on Docker Hub') {
            when{
                expression {GIT_BRANCH == 'origin/master'}
            }
            agent any
            steps{
                script {
                    sh '''
                        echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                        docker push $DOCKERHUB_USR/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
        //stage('Staging Deploy app') {
        //    agent any
        //    steps{
         //       script {
           //         sh '''
             //         echo
               // }
            //}
        //}
    }
}