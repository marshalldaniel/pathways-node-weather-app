export STAGE_FILE
export USERNAME
export PROJECT_PATH
COMPOSE_RUN_TERRAFORM = docker-compose -f docker-compose.yml -f $(STAGE_FILE) run --rm tf
COMPOSE_RUN_BASH = docker-compose -f docker-compose.yml -f $(STAGE_FILE) run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose -f docker-compose.yml -f $(STAGE_FILE) run --rm --entrypoint aws tf

.PHONY: run_plan
run_plan: init plan

.PHONY: run_apply
run_apply: init apply

.PHONY: run_destroy_plan
run_destroy_plan: init destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: init destroy_apply

.PHONY: version
version:
	$(COMPOSE_RUN_TERRAFORM) --version
	
.PHONY: init
init:
	$(COMPOSE_RUN_TERRAFORM) init
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

.PHONY: plan
plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false -var="set_username_prefix=$(USERNAME)" -var="set_project_path=$(PROJECT_PATH)"

.PHONY: apply
apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan" -var="set_username_prefix=$(USERNAME)" -var="set_project_path=$(PROJECT_PATH)"

.PHONY: destroy_plan
destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy -var="set_username_prefix=$(USERNAME)" -var="set_project_path=$(PROJECT_PATH)"

.PHONY: destroy_apply
destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve -var="set_username_prefix=$(USERNAME)" -var="set_project_path=$(PROJECT_PATH)"

.PHONY: list_bucket
list_bucket: 
	$(COMPOSE_RUN_AWS) s3 ls

