pipeline { 
    environment { 
        registry = "markdavydov/nginx_build_number" 
        registryCredential = 'dockerhub-login' 
        dockerImage = '' 
    }
    agent any 
    stages { 
        stage('Cloning our Git') { 
            steps { 
                git 'https://github.com/markrity/nginx-build.git' 
            }
        } 
        stage('Building our image') { 
            steps { 
                script { 
                    dockerImage = docker.build registry + ":$BUILD_NUMBER" 
                }
            } 
        }
        stage('Deploy our image') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push() 
                    }
                } 
            }
        } 

        stage('Apply Kubernetes files') {
            withKubeConfig([credentialsId: 'jenkins-robot', serverUrl: 'https://35.184.84.132']) {
            sh 'kubectl apply -f deployment.yaml'
            }
        }
    //     stage('Cleaning up') { 
    //         steps { 

    //             sh "docker rmi $registry:$BUILD_NUMBER" 
    //         }
    //     } 
    }
}