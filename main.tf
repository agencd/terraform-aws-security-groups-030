variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

resource "aws_security_group" "default" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "barney"
  }
}