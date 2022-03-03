export STAGE_FILE
export USERNAME
export PROJECT_PATH
export ACCOUNT_ID
export AWS_REGION 
export REPO_NAME 
DOCKERFILE = "weather-app-dockerfile"
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
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

.PHONY: destroy_plan
destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy -var="set_username_prefix=$(USERNAME)" -var="set_project_path=$(PROJECT_PATH)"

.PHONY: destroy_apply
destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve -var="set_username_prefix=$(USERNAME)" -var="set_project_path=$(PROJECT_PATH)"

.PHONY: list_bucket
list_bucket: 
	$(COMPOSE_RUN_AWS) s3 ls

.PHONY: login_ecr
login_ecr: 
    $(COMPOSE_RUN_AWS) ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

.PHONY: build_docker
build_docker: 
	cd ./weather_app
	docker build -t $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(REPO_NAME):latest -f $(DOCKERFILE) .

.PHONY: push_image
push_image: 
	cd ./weather_app
	docker push $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(REPO_NAME):latest
