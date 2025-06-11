pipeline {
    agent any

    environment {
        ANSIBLE_SERVER = "147.182.246.112"
    }

    stages {
        stage("Copy files to Ansible server") {
            steps {
                script {
                    echo "Copying files to Ansible server"
                    
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@$ANSIBLE_SERVER:/root"
                    }

                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        sh "scp -o StrictHostKeyChecking=no \$keyfile root@$ANSIBLE_SERVER:/root/ssh-key.pem"
                    }
                }
            }
        }

        stage("Run Ansible playbook") {
            steps {
                script {
                    echo "Running Ansible playbook"
                    
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile

                        // Optional: Prepare the environment (like moving keys or setting permissions)
                        sshCommand remote: remote, command: '''
                            mkdir -p /root/.ssh
                            mv /root/ssh-key.pem /root/.ssh/ssh-key.pem
                            chmod 600 /root/.ssh/ssh-key.pem
                        '''

                        // Run the playbook
                        sshCommand remote: remote, command: "ansible-playbook /root/my-playbook.yaml"
                    }
                }
            }
        }
    }
}
