variable "set_username_prefix" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "set_project_path" {
  type        = string
  description = "Project name to be used in path of SSM parameters to be exported"
  default     = ""
}
