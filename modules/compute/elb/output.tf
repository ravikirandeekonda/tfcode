output "alb_arecord" {
    value = aws_elb.app_alb.dns_name 
}