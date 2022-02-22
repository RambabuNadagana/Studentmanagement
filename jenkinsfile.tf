provider "aws" {
  region = "us-east-2"
}
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = var.name_prefix
  image_id      = var.image_id
  instance_type = var.instance_type
  security_groups    = var.security_groups
   user_data = templatefile("${path.module}/userdata.tftpl", {endpoint = aws_db_instance.default.endpoint,password = aws_db_instance.default.password,address = aws_db_instance.default.address})
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

