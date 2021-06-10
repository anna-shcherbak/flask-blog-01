
pipeline {

environment {
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
}

    agent any

    stages {
        stage("Destroy") {

            steps {
                script {
                    sh """
                    cd Terraform
                    terraform init -no-color 
                    terraform destroy --auto-approve -no-color
                    """
                }
            }
        }
    }
    post {
        always  {
            deleteDir()
        }
    }
}
