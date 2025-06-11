#!/usr/bin.env groovy

pipeline {   
    agent any
    stages {
        stage("copy files to ansible server") {
            steps{
                script{
                    echo "Copying all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']){
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@147.182.246.112:/root"
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable:'user')]) {
                            sh "scp ${keyfile} root@147.182.246.112:/root/ssh-key.pem"
                        }
                    }
                }

            }
        }
    }
}
