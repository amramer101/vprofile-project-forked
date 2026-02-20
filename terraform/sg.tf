data "http" "my_public_ip" {
  url = "http://checkip.amazonaws.com/"
}

locals {
  # Use chomp() to remove any trailing newlines or whitespace
  my_public_ip_cidr = "${chomp(data.http.my_public_ip.response_body)}/32"
}



### Security Group for the jenkins EC2 Instance

resource "aws_security_group" "jenkins-SG" {
  name        = "jenkins-sg"
  description = "Allow SSH and 8080 inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "jenkins-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_jenkins" {
  security_group_id = aws_security_group.jenkins-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_jenkins" {
  security_group_id = aws_security_group.jenkins-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_from_sonar" {
  security_group_id            = aws_security_group.jenkins-SG.id
  referenced_security_group_id = aws_security_group.sonar-SG.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}




resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_jenkins" {
  security_group_id = aws_security_group.jenkins-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}




### Security Group for the sonar EC2 Instance

resource "aws_security_group" "sonar-SG" {
  name        = "sonar-SG"
  description = "Allow ssh and 80 inbound traffic from Frontend and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "sonar-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_sonar" {
  security_group_id = aws_security_group.sonar-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_ingress_rule" "allow_80_sonar" {
  security_group_id = aws_security_group.sonar-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_from_jenkins" {
  security_group_id            = aws_security_group.sonar-SG.id
  referenced_security_group_id = aws_security_group.jenkins-SG.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_sonar" {
  security_group_id = aws_security_group.sonar-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}




### Security Group for the nexus EC2s Instance

resource "aws_security_group" "nexus-SG" {
  name        = "nexus-SG"
  description = "Allow 22 and 8081 ffic from tomcat and all outbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "nexus-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_nexus" {
  security_group_id = aws_security_group.nexus-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_8081_from_jenkins" {
  security_group_id            = aws_security_group.nexus-SG.id
  referenced_security_group_id = aws_security_group.jenkins-SG.id
  from_port                    = 8081
  ip_protocol                  = "tcp"
  to_port                      = 8081
}

resource "aws_vpc_security_group_ingress_rule" "allow_8081_from_nexus" {
  security_group_id = aws_security_group.nexus-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 8081
  ip_protocol       = "tcp"
  to_port           = 8081
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_nexus" {
  security_group_id = aws_security_group.nexus-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

