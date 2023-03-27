resource "aws_route53_zone" "route53_zone" {
        name = var.name
}

resource "aws_route53_record" "route53_record" {
        for_each = var.record_name
        zone_id = aws_route53_zone.route53_zone.zone_id
        name = each.value.host
        type = "A"
/*
        alias {
                name = data.aws_lb.elb_data.dns_name
                zone_id = data.aws_lb.elb_data.zone_id
                evaluate_target_health = true
        }
*/
                
}
