provider "aws" {
  region = "us-east-2"
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "studentmsdb"
  identifier           = "myrdb2"
  username             = "admin"
  password             = "Ramrebel56"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = ["sg-0bb5391635b3c304e"]
}
resource "aws_launch_configuration" "as_conf" {
  depends_on = [aws_db_instance.default]
  name_prefix   = "my-lc3-cli"
  image_id      = "ami-0629230e074c580f2"
  instance_type = t2.micro
  security_groups    = sg-0bb5391635b3c304es
  key_name = "jenkins"
  iam_instance_profile = "ram-s3-role"
   user_data = templatefile("${path.module}/userdata.tftpl", {endpoint = aws_db_instance.default.endpoint,password = aws_db_instance.default.password,address = aws_db_instance.default.address})
}
resource "aws_autoscaling_group" "bar" {
  name                 = "my-asg3-cli" 
  depends_on           = ["aws_launch_configuration.as_conf"]
  launch_configuration = aws_launch_configuration.as_conf.my-lc3-cli
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  target_group_arns   = ["aws_lb_target_group.test.us-east-2:931430496116:autoScalingGroup:7b57d37c-5d34-434a-ba6d-d0f7fd8ffa90:autoScalingGroupName/my-asg3-cli"]
 availability_zones = us-east-2b
}

resource "aws_autoscaling_group" "bar" {
  name                 = var.name 
  depends_on           = ["aws_launch_configuration.as_conf"]
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  target_group_arns   = [var.target_group_arns]
 availability_zones = var.availability_zones
}
}
