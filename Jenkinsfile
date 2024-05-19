pipeline {
    agent {
        label 'aws'
    }
    
    tools {
        terraform 'Terraform'
    }
    
    parameters {
        choice(name: 'WORKSPACE', choices: ['dev', 'production'], description: 'Terraform workspace (dev or production)')
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
    }
    
    environment {
        AWS_CREDENTIALS_ID = 'aws-cred'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/noranzaki/nodejs-pipeline.git'
            }    
        }
        
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Select Workspace') {
            steps {
                dir('terraform') {
                    script {
                        sh "terraform workspace select ${params.WORKSPACE} || terraform workspace new ${params.WORKSPACE}"
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                    dir('terraform') {
                        script {
                            sh "terraform plan -input=false -out=tfplan -var-file=${params.WORKSPACE}.tfvars"
                        }
                    }
                }
            }
        }
        
        stage('Execute Terraform') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                    dir('terraform') {
                        script {
                            if (params.ACTION == 'apply') {
                                sh "terraform apply -input=false tfplan -var-file=${params.WORKSPACE}.tfvars"
                            } else if (params.ACTION == 'destroy') {
                                sh "terraform destroy -auto-approve -var-file=${params.WORKSPACE}.tfvars"
                            }
                        }
                    }
                }
            }
        }
    }
}
