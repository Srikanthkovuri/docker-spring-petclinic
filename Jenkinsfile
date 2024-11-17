pipeline {
    agent any
    tools{
        maven 'maven3'
    }
    environment{
        SONAR_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
               git branch: 'main', url: 'https://github.com/Srikanthkovuri/docker-spring-petclinic.git'
                
            }
        }
        stage('compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Tests') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Trivy fs scan') {
            steps {
                sh 'trivy fs --format table -o index.html .'
            }
        }
        stage('SonarQube') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SONAR_HOME/bin/sonar -Dsonar.projectKey=springpet -Dsonar.projectName=spc \
                        -Dsonar.java.binaries=target''' 
                }
            }
        }
        stage('Build and Publish') {
            steps {
                withMaven(globalMavenSettingsConfig: 'spc-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh 'mvn deploy'
                }
            }
        }
        stage('Build & tag image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker') {
                        sh 'docker build -t srikanthkovuri/spc:latest .'
                    }
                }
            }
        }
        stage('Trivy image scan') {
            steps {
                sh 'trivy iamge --format table -o image.html srikanthkovuri/spc:latest'
            }
        }
        stage('push image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker') {
                        sh 'docker push srikanthkovuri/spc:latest'
                    }
                }
            }
        }
        
    }

}
