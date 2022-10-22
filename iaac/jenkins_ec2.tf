#### VPCs ####

#Create VPC in us-east-1
resource "aws_vpc" "vpc_jenkins" {
  provider             = aws.region-jenkins
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-jenkins"
  }

}


#Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider   = aws.region-jenkins
  vpc_id     = aws_vpc.vpc_jenkins.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "subnet-1-jenkins"
  }
}


#Create SG for allowing TCP/8080 from * and TCP/22 from external IP

resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-jenkins
  name        = "jenkins-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_jenkins.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "allow anyone on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = [var.external_ip]
  }
  egress {
    description = "allow all traffic outside"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
