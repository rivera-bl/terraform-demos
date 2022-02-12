resource "aws_emr_cluster" "this" {
  name = "${var.proj_name}-emr"
  applications = [
    "Hadoop",
    "Pig",
    "Spark",
  ]
  autoscaling_role       = "EMR_AutoScaling_DefaultRole"
  release_label          = "emr-5.34.0"
  scale_down_behavior    = "TERMINATE_AT_TASK_COMPLETION"
  service_role           = "EMR_DefaultRole"
  step                   = []
  step_concurrency_level = 1
  ebs_root_volume_size   = 10
  termination_protection = false
  visible_to_all_users   = true

  auto_termination_policy {
    idle_timeout = 3600
  }

  ec2_attributes {
    instance_profile = "EMR_EC2_DefaultRole"
    key_name         = aws_key_pair.this.id
    subnet_id        = [for s in data.aws_subnet.this : s.id][0]
  }

  master_instance_group {
    instance_count = 1
    instance_type  = "c4.large"
    name           = "${var.proj_name}-emr-master"

    ebs_config {
      iops                 = 0
      size                 = 32
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }

  core_instance_group {
    instance_count = 2
    instance_type  = "c4.large"
    name           = "${var.proj_name}-emr-core"

    ebs_config {
      iops                 = 0
      size                 = 32
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }
}
