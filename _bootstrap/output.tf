output "access-key-id" {
  value = aws_iam_access_key.this.id
}

output "access-key-secret" {
  value = aws_iam_access_key.this.encrypted_secret
}

output "console-password" {
  value = aws_iam_user_login_profile.this.encrypted_password
}
