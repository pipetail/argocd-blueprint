data "aws_route53_zone" "this" {
  name         = "dev.eks.rocks."
  private_zone = false
}