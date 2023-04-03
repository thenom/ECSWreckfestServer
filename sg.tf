data "aws_subnet" "lb_subnets" {
  for_each = toset(data.aws_lb.lb.subnets)
  id       = each.value
}

locals {
  source_cidrs = setunion([for s in data.aws_subnet.lb_subnets : s.cidr_block], var.source_cidr_blocks)
}

resource "aws_security_group" "container" {
  name   = "wreckfest"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "tcp" {
  for_each = setunion(var.tcp_ports, var.tcp_udp_ports)

  type      = "ingress"
  from_port = each.key
  to_port   = each.key
  protocol  = "tcp"

  cidr_blocks = local.source_cidrs

  security_group_id = aws_security_group.container.id
}

resource "aws_security_group_rule" "udp" {
  for_each = setunion(var.udp_ports, var.tcp_udp_ports)

  type      = "ingress"
  from_port = each.key
  to_port   = each.key
  protocol  = "udp"

  cidr_blocks = local.source_cidrs

  security_group_id = aws_security_group.container.id
}

resource "aws_security_group_rule" "egress" {
  type      = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "all"

  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.container.id
}
