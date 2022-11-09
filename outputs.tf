output "route53_fqdn" {
  value       = aws_route53_record.record.fqdn
  sensitive   = false
  description = "The DNS record name"
  depends_on  = []
}
