TF									:= $(shell which terraform)
TF_OS								?= linux
TF_ARCH							?= amd64
TF_VERSION					?= $(shell curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TF_PLUGIN_LOCATION 	?= $(HOME)/.terraform.d/plugins

TERRAFORM	:= /usr/bin/terraform

###
# Terraform makes
#
.PHONY: terraform-install
terraform-install: terraform
	sudo mv $< /usr/bin/terraform

terraform: terraform.zip
	unzip $<

# https://releases.hashicorp.com/terraform/0.12.19/terraform_0.12.19_linux_amd64.zip
terraform.zip:
	curl -L "https://releases.hashicorp.com/terraform/$(TF_VERSION)/terraform_$(TF_VERSION)_$(TF_OS)_$(TF_ARCH).zip" -o $@

.PHONY: terraform-plugin
terraform-plugin:
	mkdir -p $(TF_PLUGIN_LOCATION)

.PHONY: docker-login-check
docker-login-check:
ifndef DOCKER_TOKEN
	$(error DOCKER_TOKEN is undefined)
endif

.PHONY: docker-push-check
docker-push-check:
ifndef APP_TAG
	$(error APP_TAG is undefined)
endif


.PHONY: docker-login
docker-login: docker-login-check
	docker login --username $(DOCKER_USERNAME) -p $(DOCKER_TOKEN) 2>/dev/null

.PHONY: docker-retag-push
docker-retag-push: docker-push-check
	docker tag $(DOCKER_USERNAME)/$(DOCKER_REPO):latest $(DOCKER_USERNAME)/$(DOCKER_REPO):$(APP_TAG)
	docker push $(DOCKER_USERNAME)/$(DOCKER_REPO):$(APP_TAG)
