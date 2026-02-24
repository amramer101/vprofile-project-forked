pipeline{   
    agent any

    tools{
        jdk "JDK21"
        maven "Maven3.9"
    }

    environment {
        NEXUS_VERSION       = "nexus3"
        NEXUS_USER          = "admin"
        NEXUS_PASS          = "admin123"
        CENTRAL_REPO        = "vprofile-maven-central"
        NEXUSIP             = "10.0.1.110"
        NEXUSPORT           = "8081"
        NEXUS_REPOSITORY    = "vprofile-release"
        NEXUS_GRP_REPO      = "vprofile-group"
        NEXUS_CREDENTIAL_ID = "nexuslogin"
        ARTVERSION          = "${env.BUILD_ID}"
        SONARSERVER         = "sonarserver"
        SONARSCANNER        = "sonarscanner"
    }

    stages{
        stage("Test"){
            steps{
                sh "mvn test"
            }
        }

        stage("Checkstyle Analysis"){
            steps{
                sh "mvn checkstyle:checkstyle"
            }
        } 

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
               withSonarQubeEnv("${SONARSERVER}") {
                   sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
              }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage("Package & Archive Artifacts"){
            steps{
                sh "mvn -s settings.xml -DskipTests package"
            }
            post{
                success{
                    echo "Archiving Artifacts .." 
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }


        stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                  groupId: 'QA',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: "${RELEASE_REPO}",
                  credentialsId: "${NEXUS_LOGIN}",
                  artifacts: [
                    [artifactId: 'vproapp',
                     classifier: '',
                     file: 'target/vprofile-v2.war',
                     type: 'war']
                  ]
                )
            }
        }
    } 
}