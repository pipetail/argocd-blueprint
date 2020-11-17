locals {
  autoscaling_tags = [
    {
      key                 = "k8s.io/cluster-autoscaler/enabled"
      value               = "true"
      propagate_at_launch = false
    },
    {
      key                 = "k8s.io/cluster-autoscaler/argocd_blueprint_dev"
      value               = "owned"
      propagate_at_launch = false
    },
  ]
}