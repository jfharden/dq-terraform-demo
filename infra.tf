provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "my-terraform-state-demo"
    key = "demo/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraform-demo"
  }
}

data "aws_ami" "packer_demo" {
  most_recent = true
  filter {
    name = "name"
    values = [
      "dq-packer-demo*"]
  }
}

resource "aws_security_group" "allow_http" {
  name = "allow_http"
  description = "Allow all inbound http traffic"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = "${data.aws_ami.packer_demo.id}"
  security_groups = [
    "allow_http"]
}

output "public dns" {
  value = "${aws_instance.web.public_dns}"
}