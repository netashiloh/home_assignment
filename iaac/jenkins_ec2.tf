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

# iam_policy for Jenkins Master to ECR (not yet in use)
# need to add S3 access too
data "aws_iam_policy" "JenkinsMasterToECR" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# Start Jenkins-master instance using SG and keypair
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-jenkins
  ami                         = "ami-09d3b3274b6c5d4aa"
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.jenkins-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-master-sg.id]

  tags = {
    Name = "jenkins_master_tf"
  }

}

# Output the IP address, to connect easily via SSH
output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}