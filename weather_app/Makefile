# DOCKERFILE = weather-app-dockerfile
# export ACCOUNT_ID
# export AWS_REGION 
# export REPO_NAME 

# all: login_ecr build_docker push_image

# .PHONY: login_ecr
# aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

# .PHONY: build_docker
# docker build -t $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(REPO_NAME):latest -f $(DOCKERFILE) .

# .PHONY: push_image
# docker push $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(REPO_NAME):latest
