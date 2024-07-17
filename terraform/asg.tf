
#AutoScaling Group
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.7.0"
  depends_on = [ module.vpc ]
  name = "${var.name}-asg"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.private_subnets[*]
  
  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "java-iam-ec2"
  iam_role_description        = "IAM role for auto scaling group"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    SSM = var.ssm_policy
    CodeDeploy= var.codedeploy
    cloudwatch=var.cloudwatch_logs
    s3=var.s3_policy

  }
  security_groups       = [module.security-group.security_group_id]
  image_id          = var.image_id
  instance_type     = var.instance_type
  enable_monitoring = var.monitoring

  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]  

  user_data = base64encode(<<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -y awscli
  sudo apt-get install -y amazon-ssm-agent
  sudo apt-get install -y awslogs
  sudo systemctl start awslogs
  sudo chkconfig awslogs on
  sudo apt-get install -y ruby-full
  sudo apt-get install -y wget
  cd /home/ubuntu
  wget https://aws-codedeploy-${var.region}.s3.${var.region}.amazonaws.com/latest/install
  sudo chmod +x ./install
  sudo ./install auto > /tmp/logfile
    EOF
  )
}
