resource "aws_security_group" "allow_http" {
  name        = "allow_ec2_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "vpc-xxxxxxxxxxx"

  ingress {
    description      = "HTTP from internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Author = "renan.rodrigues"
  }
}

resource "aws_iam_role" "role" {
  name = "RoleEC2InstanceRenan"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Author = "renan.rodrigues"
  }
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "Ec2_profile" {
  name = "Ec2_profile"
  role = "${aws_iam_role.role.name}"
}

resource "aws_instance" "web" {
  ami             = "ami-067d1e60475437da2"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_http.id]
  subnet_id       = "subnet-xxxxxxxxxxxxxx"
  user_data       = "${file("user-data-nginx.sh")}"
  iam_instance_profile = aws_iam_instance_profile.Ec2_profile.name

  tags = {
    Name   = "Game2048"
    Author = "renan.rodrigues"
  }
}