# Since leveraging ECS may be too cumbersome at this stage we will use an EC2 instance with docker installed for now

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# TODO Add SG
# TODO Add Elastic IP and add it as ENV variable to codebuild
# TODO Add Role to call ECR

# We use a template_file to create the user-data script for the ec2 instance
# this is because the instance behavior depends on TF outputs such us ECR URL
data "template_file" "bootstrap_script" {
  template = "${file("../../../scripts/aws-ec2/bootstrap.tpl")}"
  
  vars {
    ECR_REGION      = "${var.REGION}"
    IMAGES_REPO_URL = "${aws_ecr_repository.aclu.repository_url}"
  }
}

resource "aws_instance" "aclu" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  user_data     = "${data.template_file.bootstrap_script.rendered}"
  key_name      = "${var.KEY_PAIR}"

  tags {
    project = "${var.APP_NAME}"
  }
}