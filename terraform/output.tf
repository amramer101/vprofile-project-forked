output "nexus_ip" {
  description = "The public IP of the nexus host"
  value       = module.ec2_instance_nexus.public_ip
}


output "jenkins_ip" {
  description = "The public IP of the jenkins host"
  value       = module.ec2_instance_Jenkins.public_ip
}


output "sonar_ip" {
  description = "The public IP of the Sonar host"
  value       = module.ec2_instance_sonar.public_ip
}