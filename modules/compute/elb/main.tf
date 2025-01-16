resource "aws_elb" "app_alb" {
    name = "app-elb"
    availability_zones = ["ap-south-1a", "ap-south-1b"]
    security_groups = [var.alb_sg_id]
    subnets = aws_subnet.public_subnet.*.id
    listener {
        instance_port = 80
        instance_protocol = "HTTP"
        lb_port = 80
        lb_protocol = "HTTP"
    }
    health_check {
        target = "HTTP:80/"
        interval = 30
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 2
    }
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400
    tags = {
        Name = "app-elb"
    } 
    depends_on = [ aws_lb_target_group.app_tg ]
}

resource "aws_lb_target_group" "app_tg" {
    name = "app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    health_check {
        path = "/"
        protocol = "HTTP"
        port = "traffic-port"
        interval = 30
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
    tags = {
        Name = "app-tg"
    }
  
}

resource "aws_lb_target_group_attachment" "app_tg_attachment1" {
    target_group_arn = aws_lb_target_group.app_tg.arn
    target_id = var.app_instance_id_1a
    port = 80
    depends_on = [ aws_lb_target_group.app_tg ]
}

resource "aws_lb_target_group_attachment" "app_tg_attachment2" {
    target_group_arn = aws_lb_target_group.app_tg.arn
    target_id = var.app_instance_id_1b
    port = 80
    depends_on = [ aws_lb_target_group.app_tg ]
}

resource "aws_lb_listener" "name" {
    load_balancer_arn = aws_elb.app_alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app_tg.arn
    }
}

