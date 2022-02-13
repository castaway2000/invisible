variable "awsprops" {
    type = "map"
    default = {
    region = "us-west-2"
    vpc = "USE YOUR VPC"
    ami = "ami-0892d3c7ee96c0bf7"  //Ubuntu 20
    itype = "t2.medium"
    subnet = "USE YOUR SUBNET NAME"
    publicip = true
    keyname = "ADD-SSH-KEY"
    secgroupname = "WebSeverSecurityGroup"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

resource "aws_security_group" "adam-flask-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  // To Allow Port 22 Transport
  ingress {
    from_port = 22
    protocol = ""
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = ""
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "project-flask" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")

  vpc_security_group_ids = [
    aws_security_group.adam-flask-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 50
    volume_type = "gp2"
  }
  tags = {
    Name ="FlaskHelloWorldAdamSzablya"
    Environment = "Dev"
    OS = "UBUNTU20"
    Managed = "Invisible"
  }

  depends_on = [ aws_security_group.adam-flask-sg ]
}

# generate inventory file for Ansible
resource "local_file" "inventory_cfg" {
  content = templatefile("${path.module}/inventory.tpl",
    {
      webservers = aws_instance.project-flask.*.public_ip
    }
  )
  filename = "../ansible/inventory.cfg"
}


output "ec2instance" {
  value = aws_instance.project-flask.public_ip
}