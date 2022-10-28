# setup security group for jenkins master
resource "aws_security_group" "jenkins-master-sg" {
  provider    = aws.region-jenkins
  name        = "jenkins-master-sg"
  description = "Allow TCP/8080 & TCP/22"
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow anyone on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow all traffic outside"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Keypair to implement in EC2 instance
resource "aws_key_pair" "jenkins-key" {
  provider   = aws.region-jenkins
  key_name   = "jenkins"
  public_key = file("/tmp/home_assignment_id_rsa.pub")
}



# EC2 policy
resource "aws_iam_role_policy" "jenkins_policy" {
  name   = "test_policy"
  role   = aws_iam_role.jenkins_role.id
  policy = file("jenkins_policy.json")
}

# EC2 role
resource "aws_iam_role" "jenkins_role" {
  name               = "jenkins_role"
  assume_role_policy = file("jenkins_ec2-assume-policy.json")
}

# Instance profile
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_profile"
  role = aws_iam_role.jenkins_role.name
}



# Start Jenkins-master instance using SG and keypair
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-jenkins
  ami                         = "ami-09d3b3274b6c5d4aa"
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.jenkins-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-master-sg.id]
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "jenkins_master"
  }

}



# Output the IP address, to connect easily via SSH
output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}