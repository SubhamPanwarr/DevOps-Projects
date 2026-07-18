pipeline {
    agent {
        label 'maven-build'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Verify Agent') {
            steps {
                sh '''
                    echo "Branch: ${BRANCH_NAME}"
                    echo "Node: ${NODE_NAME}"
                    hostname
                    whoami
                    java -version
                    mvn -version
                    git --version
                '''
            }
        }

        stage('Build Maven Project') {
            steps {
                dir('DevOps-Project-05/hello-world') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts(
                    artifacts: 'DevOps-Project-05/hello-world/webapp/target/*.war',
                    fingerprint: true,
                    allowEmptyArchive: false
                )
            }
        }
    }

    post {
        success {
            echo "Branch ${env.BRANCH_NAME} built successfully on ${env.NODE_NAME}."
        }

        failure {
            echo "Build failed for branch ${env.BRANCH_NAME}."
        }

        always {
            deleteDir()
        }
    }
}
