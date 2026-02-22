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
        NEXUSIP             = "3.126.138.115"
        NEXUSPORT           = "8081"
        NEXUS_REPOSITORY    = "vprofile-release"
	    NEXUS_GRP_REPO      = "vprofile-group"
        NEXUS_CREDENTIAL_ID = "nexuslogin"
        ARTVERSION          = "${env.BUILD_ID}"
    }


    stages{
        stage("Build"){
            steps{
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post{
                success{
                    echo "Archiving Artifacts .." 
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage("Test"){
            steps{
                sh 'mvn test'
            }
            
        }

        stage("Checkstyle Analysis"){
            steps{
                sh 'mvn checkstyle:checkstyle'
            }
            


    }
    
}    