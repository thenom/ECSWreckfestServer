data "aws_lb" "lb" {
  count = var.deploy_lb_setup ? 1 : 0
  name  = var.lb_name
}

resource "aws_lb_target_group" "tcp_container" {
  for_each = var.deploy_lb_setup ? toset(var.tcp_ports) : toset([])

  name        = "wreckfest-tcp-${each.key}"
  port        = each.key
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_lb_listener" "tcp" {
  for_each = var.deploy_lb_setup ? toset(var.tcp_ports) : toset([])

  load_balancer_arn = data.aws_lb.lb[0].arn
  port              = each.key
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcp_container[each.key].arn
  }
}

resource "aws_lb_target_group" "udp_container" {
  for_each = var.deploy_lb_setup ? toset(var.udp_ports) : toset([])

  name        = "wreckfest-udp-${each.key}"
  port        = each.key
  protocol    = "UDP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_lb_listener" "udp" {
  for_each = var.deploy_lb_setup ? toset(var.udp_ports) : toset([])

  load_balancer_arn = data.aws_lb.lb[0].arn
  port              = each.key
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.udp_container[each.key].arn
  }
}

resource "aws_lb_target_group" "tcp_udp_container" {
  for_each = var.deploy_lb_setup ? toset(var.tcp_udp_ports) : toset([])

  name        = "wreckfest-tcp-udp-${each.key}"
  port        = each.key
  protocol    = "TCP_UDP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_lb_listener" "tcp_udp" {
  for_each = var.deploy_lb_setup ? toset(var.tcp_udp_ports) : toset([])

  load_balancer_arn = data.aws_lb.lb[0].arn
  port              = each.key
  protocol          = "TCP_UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcp_udp_container[each.key].arn
  }
}
