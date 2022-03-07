################################################################################
### Initial config variables
################################################################################

variable "set_username_prefix" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = null
}

# variable "set_custom_tags" {
#   type        = map(string)
#   description = "Use tags to identify project resources"
#   default = {
#     Project_Name = "pathways-node-weather-app"
#   }
# }

variable "set_project_path" {
  type        = string
  description = "Project name to be used in path of SSM parameters to be exported"
  default     = null
}
