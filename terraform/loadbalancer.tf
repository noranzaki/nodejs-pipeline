resource "aws_lb" "my_lb" {
    name               = "nodejs-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets = [
        module.network.subnets["public1"].id,
        module.network.subnets["public2"].id
    ]
    tags = {
        Name = "nodejs-lb"
    }
}


resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id   = module.network.vpc_id

  health_check {
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    timeout             = 5
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "my-target-group"
  }
  
}


resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.application.id
  port             = 3000
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}