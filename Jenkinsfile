pipeline {
    agent {
        label 'aws'
    }
    
    tools {
        terraform 'terraform'
    }
    parameters {
        choice(name: 'WORKSPACE', choices: ['dev', 'production'], description: 'Terraform workspace (dev or production)')
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS-Access-Key-ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-Key')
        AWS_DEFAULT_REGION    = 'eu-west-1'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/noranzaki/nodejs-pipeline.git'
            }    
        }
        stage('Terraform init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }
        stage('Select Workspace') {
            steps {
                dir('terraform') {
                    sh "terraform workspace select ${params.WORKSPACE} || terraform workspace new ${params.WORKSPACE}"
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh "terraform plan -var-file=${params.WORKSPACE}.tfvars"
                }
            }
        }
        stage('Terraform Apply/Destroy') {
            steps {
                dir('terraform') {
                    script {
                        if (params.ACTION == 'apply') {
                            sh "terraform apply -auto-approve -var-file=${WORKSPACE}.tfvars"
                        } else if (params.ACTION == 'destroy') {
                            sh "terraform destroy -auto-approve -var-file=${WORKSPACE}.tfvars"
                        }
                    }
                }
            }
        } 
    }
}