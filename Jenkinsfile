// 1641-job2-pipeline

pipeline {

    agent {
        label ('node-slv1')
    }
   
    parameters {
        string(name: 'upstream_job_name')
        string(name: 'artifact_id')
    }

    stages {
        stage('Copy artifact') {
            steps {
                copyArtifacts filter: 'target/${artifact_id}.war', fingerprintArtifacts: true,
                projectName: upstream_job_name, selector: lastSuccessful()
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'cd $WORKSPACE/target && tar -czf ${artifact_id}.tar.gz ${artifact_id}.war'
                    sh 'scp $WORKSPACE/deploy.sh student@vm-a:/opt/1641-backup/'
                    sh 'scp $WORKSPACE/target/${artifact_id}.tar.gz student@vm-a:/opt/1641-backup/'
                    sh 'ssh student@vm-a /opt/1641-backup/deploy.sh ${artifact_id}.tar.gz'
                }
            }
        }
        stage ('Retrive downstream job') {
            steps {
                build job: '1641-job3-pipeline',
                parameters: [string(name: 'artifact_id', value: artifact_id)],
                wait: false
            } 
        }
    }

    post {
        failure {
            emailext to: 'student@vm-a.localdomain',                
            subject: 'The ${JOB_NAME} build-${BUILD_NUMBER}  is ${BUILD_STATUS}',
//            attachLog: true,
            body:  'The ${JOB_NAME} build-${BUILD_NUMBER} Deploy is ${BUILD_STATUS}.'
        }
    }

}

