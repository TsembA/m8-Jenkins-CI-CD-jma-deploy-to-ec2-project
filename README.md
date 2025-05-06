# 🚀 Java CI/CD Pipeline with Jenkins, Docker & AWS EC2

This project sets up a **Jenkins pipeline** for automating the build, Dockerization, and deployment of a Java-Maven application using a **Jenkins Shared Library** and **AWS EC2** as the deployment target.

---

## 📦 Overview

The pipeline performs the following steps:

1. **Build the application** using Maven.
2. **Create a Docker image** of the application.
3. **Push the image** to a Docker registry.
4. **Deploy the image** to an EC2 instance using SSH.

---

## 🛠️ Technologies Used

- **Java 11** (assumed for Maven build)
- **Maven 3.9**
- **Docker**
- **Jenkins (Declarative Pipeline)**
- **Jenkins Shared Library**
- **AWS EC2 (Amazon Linux)**
- **GitHub (source control)**

---

## 📁 Pipeline Structure

### 🔗 Shared Library

```groovy
library identifier: 'jenkins-shared-library@master', retriever: modernSCM(...)
```

- Reuses common functions like `buildJar()`, `buildImage()`, `dockerLogin()`, `dockerPush()`.

### 🧱 Pipeline Stages

#### 🏗️ Build Stage

```groovy
buildJar()
```
- Compiles Java code and creates a `.jar` using Maven.

#### 🐳 Docker Stage

```groovy
buildImage(env.IMAGE_NAME)
dockerLogin()
dockerPush(env.IMAGE_NAME)
```
- Builds and pushes Docker image to the registry.

#### 🚀 Deployment Stage

```groovy
sshagent(['ec2-server-key']) {
    sh "ssh ec2-user@<EC2-IP> docker run ..."
}
```
- Connects to the EC2 instance and runs the Docker container.

---

## 🌐 Environment Variables

```groovy
environment {
    IMAGE_NAME = 'tsemb/demo-app:java-maven-1.0'
}
```

---

## 🔐 Credentials

- `github-credentials` for accessing the shared library repo.
- `ec2-server-key` for SSH access to the EC2 instance.

---

## 📌 Notes

- Ensure Docker is installed on the EC2 instance.
- The shared library must be accessible from Jenkins.
- Ports must be open in the EC2 security group (e.g., `3080`).

---
