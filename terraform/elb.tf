resource "aws_lb" "gitlab_lb" {
  name               = "gitlab-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.gitlab_sg.id]
  subnets            =  [for subnet in aws_subnet.public_subnets : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "gitlab-lb"
  }
}


resource "aws_lb_listener" "gitlab_listener" {
  load_balancer_arn = aws_lb.gitlab_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab_tg.arn
  }
}