def branch = "staging"
def repo = "git@github.com:Ariifprastiyo/fe-dumbmerch.git"
def cred = "dumbmerch"
def dir = "~/fe-dumbmerch"
def server = "arif@103.176.79.201"
def imagename = "dumbmerch-fe"
def dockerusername = "ariif"

pipeline {
    agent any

    stages {
        stage('Repository pull') {
            steps {
                sshagent([cred]) {
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                                mkdir ${dir}
                        cd ${dir}
                                    git init
                        git remote add origin ${repo}
                                    git pull origin master
                                    git branch ${branch}
                                    git checkout ${branch}
                                    git pull origin ${branch}
                        exit
                        EOF
                    """
                }
            }
        }

    stage('Image build') {
            steps {
                sshagent([cred]) {
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${dir}
                        docker build -t ${imagename}:latest .
                        exit
                        EOF
                    """
                }
            }
        }

        stage('Running the image in a container') {
            steps {
                sshagent([cred]) {
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${dir}
                        docker container stop ${imagename}
                        docker container rm ${imagename}
                        docker run -d -p 3000:3000 --name="${imagename}"  ${imagename}:latest
                        docker container stop ${imagename}
                        docker container rm ${imagename}
                        exit
                        EOF
                    """
                }
            }
        }

        stage('Image push') {
            steps {
               sshagent([cred]) {
                            sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                                    docker tag ${imagename}:latest ${dockerusername}/${imagename}:latest
                                    docker image push ${dockerusername}/${imagename}:latest
                                    docker image rm ${dockerusername}/${imagename}:latest
                                    docker image rm ${imagename}:latest
                                    exit
                    EOF
                        """
                        }
            }
        }
    }
}
