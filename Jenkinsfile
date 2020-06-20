// 1641-job3-pipeline

pipeline {

    agent {
        label ('master')
    }
    
    parameters {
        string(name: 'artifact_id')
    }
    
    stages {
        stage ('Receive http request'){
            steps {
                script {
                    int result = sh (script: "curl -IL http://vm-b:8080/${artifact_id} -o /dev/null -s -w '%{http_code}\n'", returnStdout: true)
                    http_result = result
                }
            }
        }
        stage ('Mailing http request'){
            steps {
                script {
                    if ( http_result == 200) {
                        emailext attachLog: true, \
                        body: 'http://vm-b:8080/${artifact_id} application status is OK! ${BUILD_URL}', \
                        subject: 'The ${JOB_NAME} build-${BUILD_NUMBER}  is ${BUILD_STATUS}', \
                        to: 'student@vm-a.localdomain'
                    }
                    else {
                        emailext attachLog: true, \
                        body: 'http://vm-b:8080/${artifact_id} application status is NOT OK! ${BUILD_URL}', \
                        subject: 'The ${JOB_NAME} build-${BUILD_NUMBER}  is ${BUILD_STATUS}', \
                        to: 'student@vm-a.localdomain'
                    }
                }
            }
        }
    }

}

