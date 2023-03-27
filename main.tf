# ALB
resource "aws_lb" "nh_alb" {
  name               = "nh-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.is_portal_sg == true ? [data.aws_security_group.kibo-sg[0].id] : [aws_security_group.sg[0].id]
  #subnets            = [var.is_portal_subnet == true ? data.aws_subnet.kibo-subnet-01[0].id : aws_subnet.new_subnet[0].id]
  #subnets            =  [for subnet in aws_subnet.new_subnet : subnet.id]
  dns_name              = "test_dns"
        
   subnet_mapping {
    subnet_id            = var.is_portal_subnet == true ? data.aws_subnet.kibo-subnet-01[0].id : aws_subnet.new_subnet[0].id
    #private_ipv4_address = "10.0.1.15"
  }
 subnet_mapping {
    subnet_id            = var.is_portal_subnet == true ? data.aws_subnet.kibo-subnet-01[0].id : aws_subnet.lb_subnet[0].id
    #private_ipv4_address = "10.0.2.15"
  }
  enable_deletion_protection = false
  
  tags = {
    Environment = "production"
  }
}

resource "aws_route53_zone" "route53_zone" {
        name = var.name
}

resource "aws_route53_record" "route53_record" {
        for_each = var.names
        zone_id = aws_route53_zone.route53_zone.zone_id
        name = each.value.host
        type = "A"

        alias {
                name = aws_lb.nh_alb.dns_name
                zone_id = aws_route53_zone.route53_zone.zone_id
                evaluate_target_health = true
        }

                
}
