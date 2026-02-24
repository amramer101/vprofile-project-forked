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
        NEXUSIP             = "63.178.240.164"
        NEXUSPORT           = "8081"
        NEXUS_REPOSITORY    = "vprofile-release"
        NEXUS_GRP_REPO      = "vprofile-group"
        NEXUS_CREDENTIAL_ID = "nexuslogin"
        ARTVERSION          = "${env.BUILD_ID}"
        SONARSERVER         = "sonarserver"
        SONARSCANNER        = "sonarscanner"
    }

    stages{
        // 1. مرحلة الاختبار الأولية
        stage("Test"){
            steps{
                // بنعمل كومبايل واختبار من غير ما نعمل war
                sh "mvn test"
            }
        }

        // 2. تحليل الكود بالـ Checkstyle
        stage("Checkstyle Analysis"){
            steps{
                sh "mvn checkstyle:checkstyle"
            }
        } 

        // 3. تحليل الكود بالسونار كيوب
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

        // 4. بوابة الجودة (لو الكود سيء البايبلاين هيقف هنا)
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        // 5. التجميع والأرشفة (هنا بس نعمل الـ war بعد ما اتأكدنا ان الكود سليم)
        stage("Package & Archive Artifacts"){
            steps{
                // بنستخدم package وبنتجاهل الـ tests لأننا عملناها فوق خلاص
                sh "mvn -s settings.xml -DskipTests package"
            }
            post{
                success{
                    echo "Archiving Artifacts .." 
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
    } 
}