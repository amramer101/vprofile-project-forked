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
        NEXUSIP             = "54.93.63.35"
        NEXUSPORT           = "8081"
        NEXUS_REPOSITORY    = "vprofile-release"
	    NEXUS_REPOGRP_ID    = "vprofile-group"
        NEXUS_CREDENTIAL_ID = "nexuslogin"
        ARTVERSION          = "${env.BUILD_ID}"
    }


    stages{
        stage("Build"){
            steps{
                sh "mvn -s settings.xml -DskipTests install"
            }
 

    }
    }

}    