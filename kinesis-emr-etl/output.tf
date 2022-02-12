output "ec2_public_ip" {
  value = aws_instance.this.public_ip
}

output "emr_master_endpoint" {
  value = aws_emr_cluster.this.master_public_dns
}
