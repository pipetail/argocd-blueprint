module "this" {
  for_each = var.queues
  source   = "terraform-aws-modules/sqs/aws"
  version  = "~> 2.0"
  name     = lookup(each.value, "name", null)
}
