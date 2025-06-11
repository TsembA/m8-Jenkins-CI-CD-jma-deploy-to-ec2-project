pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "147.182.246.112"
    }
    stages {
        stage("copy files to ansible server") {
            steps {
                script {
                    echo "Copying files to Ansible control node"
                    sshagent(['ansible-server-key']) {
                        // Copy ansible playbook and config files
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@${ANSIBLE_SERVER}:/root"
                        // Copy EC2 key to the Ansible server
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            sh "scp \$keyfile root@${ANSIBLE_SERVER}:/root/.ssh/ssh-key.pem"
                        }
                        // Copy the preparation script
                        sh "scp prepare-ansible-server.sh root@${ANSIBLE_SERVER}:/root/"
                    }
                }
            }
        }
        stage("execute ansible playbook") {
            steps {
                script {
                    echo "Calling Ansible playbook to configure EC2 instances"

                    def remote = [:]
                    remote.name = 'ansible-server'
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile

                        // Run the shell script
                        sshScript remote: remote, script: '/root/prepare-ansible-server.sh'

                        // Run the ansible playbook
                        sshCommand remote: remote, command: 'ansible-playbook /root/my-playbook.yaml'
                    }
                }
            }
        }
    }
}
