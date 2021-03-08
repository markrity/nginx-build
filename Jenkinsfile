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
                    //dockerImage = docker.build registry + ":$BUILD_NUMBER" 
                    dockerImage = docker.build("$registry:${env.BUILD_NUMBER}", "--build-arg BUILD_NUMBER=$BUILD_NUMBER .")
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
            steps{
            withKubeConfig([credentialsId: 'candidate-sa', serverUrl: 'https://35.184.84.132']) {
            sh 'cat deployment.yaml | sed "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" | kubectl apply -f -'
            }
            }
        }
}
