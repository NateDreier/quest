resource "aws_security_group" "lb_sg" {
  provider    = aws.region-east-primary
  name        = "lb_sg"
  description = "Allow 443 and traffic to Quest SG"
  vpc_id      = var.vpc_east_primary_id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.external_ips]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.external_ips]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.external_ips]
  }
}

resource "aws_lb" "lb-quest" {
  provider           = aws.region-east-primary
  name               = "quest-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [var.subnet_east_1_id, var.subnet_east_2_id]
  tags = {
    Name = "Quest-LB"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-east-primary
  name        = "app-lb-tg"
  port        = 80
  target_type = "instance"
  vpc_id      = var.vpc_east_primary_id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = 80
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    "Name" = "quest-target-group"
  }
}

resource "aws_lb_listener" "quest-listener" {
  provider          = aws.region-east-primary
  load_balancer_arn = aws_lb.lb-quest.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.quest_lb_https.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }

}

resource "aws_lb_listener" "quest-listener-http" {
  provider          = aws.region-east-primary
  load_balancer_arn = aws_lb.lb-quest.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#resource "aws_lb_target_group_attachment" "quest-master-attach" {
#  provider         = aws.region-east-primary
#  target_group_arn = aws_lb_target_group.app-lb-tg.arn
#  target_id        = aws_instance.quest-master-west.id
#  port             = var.webserver-port
#}
