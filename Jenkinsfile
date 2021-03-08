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
    //     stage('Cleaning up') { 
    //         steps { 

    //             sh "docker rmi $registry:$BUILD_NUMBER" 
    //         }
    //     } 
    }
}