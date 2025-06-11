# Jenkins + Ansible CI/CD Pipeline for Dockerized EC2 Deployment

This project automates the provisioning and configuration of AWS EC2 instances using **Ansible**, and sets up a **Jenkins CI/CD pipeline** to deploy applications using **Docker** and **Docker Compose**.

## 🔧 Tech Stack

- **Jenkins** (Pipeline as Code - `Jenkinsfile`)
- **Ansible** (Remote configuration)
- **Docker & Docker Compose** (App containerization)
- **AWS EC2** (Target deployment instances)
- **GitHub** (SCM + webhook trigger)

## 📦 Features

- CI/CD pipeline triggered from GitHub push
- File transfer to remote Ansible control node
- Remote execution of Ansible playbooks via SSH
- Installs Docker and Docker Compose on EC2 instances
- Uses SSH agent forwarding and credentials securely via Jenkins

## 📁 Project Structure

```
.
├── Jenkinsfile                  # Jenkins pipeline definition
├── prepare-ansible-server.sh   # Script to prepare Ansible control node
└── ansible/
    ├── ansible.cfg             # Ansible configuration
    ├── inventory_aws_ec2.yaml  # Static inventory of EC2 instances
    └── my-playbook.yaml        # Playbook to install Docker & Compose
```

## 🚀 CI/CD Workflow

1. **Checkout Source**  
   Jenkins checks out the source from GitHub.

2. **Transfer Files to Ansible Node**  
   Jenkins securely copies Ansible files and credentials to the control node.

3. **Prepare Ansible Server**  
   Runs `prepare-ansible-server.sh` to install Python dependencies like `boto3` and `botocore`.

4. **Run Ansible Playbook**  
   Jenkins remotely executes `my-playbook.yaml` on EC2 instances to install Docker and Docker Compose.

## 🔐 Required Jenkins Credentials

| ID                  | Type              | Used For                             |
|---------------------|-------------------|--------------------------------------|
| `github-credentials`| Username + Token  | GitHub source checkout               |
| `ansible-server-key`| SSH Private Key   | SSH into Ansible control node        |
| `ec2-server-key`    | SSH Private Key   | Copied to Ansible server for EC2 SSH |

## 🛠️ Prerequisites

- EC2 instance with public IP as Ansible control node
- Target EC2 instances accessible via private key
- Jenkins server with required plugins:
  - SSH Agent Plugin
  - Pipeline Plugin
  - SSH Steps Plugin

## 🧪 Running the Pipeline

1. Push to the `feature/ansible` branch
2. Jenkins automatically triggers the pipeline
3. EC2 instances get configured with Docker & Docker Compose
