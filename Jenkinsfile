#!/usr/bin.env groovy
pipeline {   
    agent any
    environment{
        ANSIBLE_SERVER = "147.182.246.112"
    }
    stages {
        stage("copy files to ansible server") {
            steps{
                script{
                    echo "Copying all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']){
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@${ANSIBLE_SERVER}:/root"
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable:'user')]) {
                            sh 'scp $keyfile root@${ANSIBLE_SERVER}:/root/.ssh/ssh-key.pem'
                        }
                    }
                }

            }
        }
        stage("execute ansible playbook"){
            steps{
                script{
                    echo "Calling ansible playbook to configure EC2 instances"
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable:'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile
                        sshScript remote: remote, script: "prepare-ansible-server.sh"
                        sshCommand remote: remote, command: "ansible-playbook my-playbook.yaml"
                    }
                    
                }
            }
        }
    }
}
