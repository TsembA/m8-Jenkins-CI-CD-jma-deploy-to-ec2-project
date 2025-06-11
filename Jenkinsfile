#!/usr/bin/env groovy
pipeline {
    agent any

    stages {
        stage("Copy files to Ansible server") {
            steps {
                script {
                    echo "Copying all necessary files to Ansible control node"

                    sshagent(['ansible-server-key']) {
                        // Copy Ansible folder to remote Ansible server
                        sh "scp -o StrictHostKeyChecking=no -r ansible/* root@147.182.246.112:/root"

                        // Copy EC2 SSH key to Ansible server
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            sh 'scp -o StrictHostKeyChecking=no $keyfile root@147.182.246.112:/root/ssh-key.pem'
                        }
                    }
                }
            }
        }

        stage("Execute Ansible playbook") {
            steps {
                script {
                    echo "Calling Ansible playbook to configure EC2 instances"

                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = "147.182.246.112"
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile
                        sshCommand remote: remote, command: "ansible-playbook /root/deploy-ec2.yaml"
                    }
                }
            }
        }
    }
}
