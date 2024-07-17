module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
  depends_on = [ module.asg, module.vpc]
  name = "${var.name}-alb"
  load_balancer_type = "application"
  vpc_id          = module.vpc.vpc_id 
  subnets         = module.vpc.public_subnets
  security_groups = [module.security-group.security_group_id]
  create_security_group = false
  target_groups = [
    {
      name_prefix      = "java-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/my_books"
        port                = 8080
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
      }
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  
}

