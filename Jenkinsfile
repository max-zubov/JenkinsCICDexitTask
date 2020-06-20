// main job 1641-job1-pipeline

pipeline {

    agent {
        label (' master')
    }

    environment {
        artifact_id = 'spring-kitchensink-basic'
    }

    options {
        copyArtifactPermission('1641-job2-pipeline')
    }
    
    tools {
        maven "maven-3"
        jdk "java-8"
    }
    
    triggers { pollSCM('H/5 * * * *') }

   
    stages {
        stage('Retrive git') {
            steps {
                git 'https://github.com/max-zubov/JenkinsCICDexitTask.git'
            }
        }
        stage('Build') {
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean install"
            }
            post {
                success {
                   junit '**/target/surefire-reports/TEST-*.xml'
                   archiveArtifacts "target/${artifact_id}.war"
                }
            }

        }
        stage ('Publisher in Nexus') {
            steps {
                nexusPublisher nexusInstanceId: '874F0460-C60C131F-290A9685-269703A3-ED9DC463',
                nexusRepositoryId: 'maven-releases',
                packages: [[$class: 'MavenPackage',
                mavenAssetList: [[classifier: '', extension: '', filePath: "target/${artifact_id}.war"]],
                mavenCoordinate: [artifactId: artifact_id, groupId: 'edu.epam.zubov', packaging: 'war', version: '0.1.00-${BUILD_NUMBER}']]]
            }
        }
        stage ('Sonar') {
            steps {
                withSonarQubeEnv('sonar-8') {
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.6.0.1398:sonar'
                }
            }
       }
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate  abortPipeline: true
                }
            }
        }        
        stage ('Retrive downstream job') {
            steps {
               build job: '1641-job2-pipeline',
                parameters: [string(name: 'upstream_job_name', value: JOB_NAME),
                             string(name: 'artifact_id', value: artifact_id)],
                wait: false
            } 
        }
    }
    post {
        failure {
            emailext to: 'student@vm-a.localdomain',                
            subject: 'The ${JOB_NAME} build-${BUILD_NUMBER}  is ${BUILD_STATUS}',
//            attachLog: true,
            body:  'The ${JOB_NAME} build-${BUILD_NUMBER} is ${BUILD_STATUS}.'
        }
    }

}

