################################################################################
### Initial config variables
################################################################################

variable "set_username_prefix" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = ""
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
  default     = ""
}

################################################################################
### terraform_ecs module variables
################################################################################

# variable "set_ecs_name" {
#   type        = string
#   description = "Name to be used on all the resources as identifier, also the name of the ECS cluster"
#   default     = ""
# }

# variable "set_create_ecs" {
#   type        = bool
#   description = "Controls if ECS should be created"
#   default     = true
# }

# variable "set_container_insights" {
#   type        = bool
#   description = "Controls if ECS Cluster has container insights enabled"
#   default     = true
# }
