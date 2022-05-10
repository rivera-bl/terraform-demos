output "default-vpc-first-subnet" {
  value = [for s in data.aws_subnet.this : s.id][0]
}
