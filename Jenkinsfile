#!/usr/bin/env groovy
pipeline {   
    agent any
    stages {
        stage("copy files to ansible server") {
            steps {
                script {
                    echo "Copying all necessary files to Ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@147.182.246.112:/root"
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable:'user')]) {
                            sh 'scp $keyfile root@147.182.246.112:/root/ssh-key.pem'
                        }
                    }
                }
            }
        }

        stage("execute ansible playbook") {
            steps {
                script {
                    echo "Calling Ansible playbook to configure EC2 instances"

                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable:'user')]) {
                        def remote = [
                            name: "ansible-server",            // ✅ required
                            host: "147.182.246.112",           // ✅ required
                            user: user,
                            identityFile: keyfile,
                            allowAnyHosts: true
                        ]

                        sshCommand remote: remote, command: "ansible-playbook /root/my-playbook.yaml"
                    }
                }
            }
        }
    }
}
