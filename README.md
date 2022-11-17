# Home assignment
✨ Project completed ✨

The project tasks are:
- Create docker file to run python http module - *done*
- Write IAAC for EC2 instance - *done*
- Write IAAC for ECR repository - *done*
- Write IAAC for EKS cluster - *done*
- Deploy Jenkins on the EC2 instance/s - *done*
- Create CI pipeline to create ECR repo, build docker image and push it to the ECR - *done*
- Create job on Jenkins to run the created pipeline - *done*
- Write a deployment for the docker application to run on the EKS cluster - *done*

#### Prequisites:
 - AWS account
 - Work environment(eg: WSL2 / ec2) with the following software installations
##### installations:
- *Git* 
- *Docker*
- *awscli*
- *Terraform*
- *kubectl*



#### Before applying Terraform:
##### Setup your user:
Create an Iam user with code access only to the relevant access.
Generate Keypair & configure your environment:
*aws configure*

##### Setup your backened: 
Create S3 bucket for the statefile using awscli:
*aws s3api create-bucket --bucket <bucketname>*
You will need to edit the backened.tf for each folder (EKS, ecr, Jenkins_EC2) and modify the bucket name in bucket  = "".


##### Jenkins_EC2:
Before applying the code, generate a ppk to push to the EC2.
*ssh-keygen -t rsa*

*I saved the ppk under /tmp/home_assignment_id_rsa/ and that's where it expects to find the key. If it's different please edit the "aws_key_pair" resource under iaac/Jenkins_EC2/main.tf


change it’s permissions:
*chmod 600 /tmp/home_assignment_id_rsa*

You can now get to work!