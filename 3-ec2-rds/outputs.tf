output "default-vpc-first-subnet" {
  value = [for s in data.aws_subnet.this : s.id][0]
}

output "ami_id" {
  value = module.ec2_instance_basic.ami_id
}

output "instance_public_ip" {
  value = module.ec2_instance_basic.instance_public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}
