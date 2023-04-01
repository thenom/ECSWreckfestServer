resource "aws_security_group" "container" {
  name   = "wreckfest"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "tcp" {
  for_each = var.tcp_ports

  type      = "ingress"
  from_port = each.key
  to_port   = each.key
  protocol  = "tcp"

  cidr_blocks = var.source_cidr_blocks

  security_group_id = aws_security_group.container.id
}

resource "aws_security_group_rule" "udp" {
  for_each = var.udp_ports

  type      = "ingress"
  from_port = each.key
  to_port   = each.key
  protocol  = "udp"

  cidr_blocks = var.source_cidr_blocks

  security_group_id = aws_security_group.container.id
}
