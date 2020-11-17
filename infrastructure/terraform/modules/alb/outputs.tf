output "security_group_id" {
  value = aws_security_group.this.id
}

output "http_lb_target_group_id" {
  value = aws_lb_target_group.http.id
}

output "https_lb_target_group_id" {
  value = aws_lb_target_group.https.id
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}