variable "security_groups" {
  description = "A map of lists of security group objects to create"
  type = map(object({
    description = string
    vpc_id      = string
    ingress_rules = optional(list(object({
      from_port        = number
      to_port          = number
      description      = string
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      security_groups  = optional(list(string))
    })))
    egress_rules = optional(list(object({
      from_port        = number
      to_port          = number
      description      = string
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      security_groups  = optional(list(string))
    })))
  }))
}

resource "aws_security_group" "default" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.description
  vpc_id      = each.value.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress_rules != null ? each.value.ingress_rules : []
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      description      = ingress.value.description
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks != null ? ingress.value.ipv6_cidr_blocks : []
      security_groups  = ingress.value.security_groups != null ? ingress.value.security_groups : []
    }
  }
  dynamic "egress" {
    for_each = each.value.egress_rules != null ? each.value.egress_rules : []
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      description      = egress.value.description
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks != null ? egress.value.ipv6_cidr_blocks : []
      security_groups  = egress.value.security_groups != null ? egress.value.security_groups : []
    }
  }
}

output "security_group_ids" {
  value = { for sg in aws_security_group.default : sg.name => sg.id }
}