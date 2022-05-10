variable "region" {
  type        = string
  description = "Region where the resources will be created"
}

variable "project_name" {
  type        = string
  description = "Name of this architecture project"
}

variable "email" {
  type        = string
  description = "Name of the email to send the sns messages"
}
