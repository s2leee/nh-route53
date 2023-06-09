terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws"{
access_key=var.access_key
secret_key=var.secret_key
region="ap-northeast-2"
}

# ALB
resource "aws_lb" "nh_alb" {
  name               = "nh-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-05f6833f701143e65"]
  #subnets            = [var.is_portal_subnet == true ? data.aws_subnet.selee-subnet[0].id : aws_subnet.new_subnet[0].id]
  #subnets            =  [for subnet in aws_subnet.new_subnet : subnet.id]
  #dns_name              = "test_dns"
        
   subnet_mapping {
    subnet_id            = "subnet-0548a4b00ffb7b1f5"
    #private_ipv4_address = "10.0.1.15"
  }
 subnet_mapping {
    subnet_id            = "subnet-0d37f77be8c1b8329"
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
        name = each.key
        type = "A"

        alias {
                #name = aws_lb.nh_alb.dns_name
                name = "nh-alb-431188028.ap-northeast-2.elb.amazonaws.com"
                zone_id = aws_lb.nh_alb.zone_id
                evaluate_target_health = true
        }

                
}
