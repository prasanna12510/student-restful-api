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

.PHONY:validate-commit-sha-check
validate-commit-sha-check:
ifndef INPUT_COMMIT_SHA
	$(error INPUT_COMMIT_SHA is undefined)
endif

ifndef GITHUB_HEAD_COMMIT_SHA
	$(error GITHUB_HEAD_COMMIT_SHA is undefined)
endif

.PHONY: validate-commit-sha
HEAD_COMMIT_SHA := $(patsubst "%",%,$(GITHUB_HEAD_COMMIT_SHA))
validate-commit-sha:validate-commit-sha-check
ifneq ($(HEAD_COMMIT_SHA), $(INPUT_COMMIT_SHA))
	$(error $(HEAD_COMMIT_SHA) and $(INPUT_COMMIT_SHA) not match)
else
	@echo validation completed
endif

.PHONY: docker-login-check
docker-login-check: git-setup
ifndef DOCKER_TOKEN
	$(error DOCKER_TOKEN is undefined)
endif

.PHONY: docker-registry-token-check
docker-registry-token-check:
ifndef  QUAY_ACCESS_TOKEN
	$(error QUAY_ACCESS_TOKEN is undefined)
endif

.PHONY: docker-login
docker-login: docker-login-check
	docker login $(DOCKER_HOST) --username $(DOCKER_USERNAME) -p $(DOCKER_TOKEN) 2>/dev/null

.PHONY: docker-build
docker-build: docker-login
	sudo docker build --file $(DOCKER_FILE_PATH)/Dockerfile --tag $(DOCKER_IMAGE):$(APP_TAG) --build-arg SSH_PRV_KEY="$$(cat ~/.ssh/id_rsa)" --build-arg SSH_PUB_KEY="$$(cat ~/.ssh/id_rsa.pub)" $(DOCKER_FILE_PATH)

.PHONY: docker-pull
docker-pull: docker-login
	sudo docker pull $(DOCKER_IMAGE):$(BRANCH_TAG)

.PHONY: docker-retag-push
docker-retag-push: docker-pull
	sudo docker tag $(DOCKER_IMAGE):$(BRANCH_TAG) $(DOCKER_IMAGE):$(MASTER_TAG)
	sudo docker push $(DOCKER_IMAGE):$(MASTER_TAG)

.PHONY: docker-push
docker-push: docker-build
	sudo docker push $(DOCKER_IMAGE):$(APP_TAG)

.PHONY: terraform-destroy-check
terraform-destroy-check:
ifndef TF_TOKEN
	$(error TF_TOKEN is undefined)
endif
ifndef TF_TOKEN_TO_BE_REPLACED
	$(error TF_TOKEN_TO_BE_REPLACED is undefined)
endif
ifndef TF_WORKSPACE
	$(error TF_WORKSPACE is undefined)
endif
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
endif
ifndef SERVICE_NAME
	$(error SERVICE_NAME is undefined)
endif
ifndef TF_FILE_PATHS
	$(error TF_FILE_PATHS is undefined)
endif
ifeq ($(TF_WORKSPACE),play)
	echo "destroy in play account"
else
	$(error TF_WORKSPACE whould be play only)
endif

.PHONY: terraform-destroy
terraform-destroy: terraform-destroy-check
	{ \
	CWD=`pwd`; \
	for TF_FILE_PATH in $(TF_FILE_PATHS); \
	do \
		cd $$CWD/services/$(SERVICE_NAME)/$$TF_FILE_PATH; \
		sed -i -e "s/$(TF_TOKEN_TO_BE_REPLACED)/$(TF_TOKEN)/g" *.tf; \
		sed -i -e "s/SED_TF_TOKEN_CLOUD_SRE/$(TF_TOKEN_CLOUD_SRE)/g" *.tf; \
		sed -i -e "s/TF_TOKEN_CLOUD_SRE/$(TF_TOKEN_CLOUD_SRE)/g" *.tf; \
		$(TERRAFORM) init -input=false; \
		$(TERRAFORM) plan -destroy -input=false; \
		$(TERRAFORM) destroy -input=false -auto-approve; \
	done; \
	}

.PHONY: terraform-rc
terraform-rc:
	printf '%s\n' 'credentials "app.terraform.io" {' 'token = "$(TF_TOKEN)"' '}' > $(HOME)/.terraformrc && cat ~/.terraformrc

# append environments
ENVS := play
ENVS += stag
ENVS += prod

.PHONY: terraform-workspace-creation
terraform-workspace-creation:terraform-rc
	for i in $(ENVS); \
    do \
    CWD=`pwd`; \
    cd $$CWD/$(BACKEND_DIR); \
    terraform init || true && export TF_WORKSPACE=$$i && terraform workspace new $$i || true; \
    curl -X PATCH https://app.terraform.io/api/v2/organizations/$(TFCLOUD_ORGANIZATION_NAME)/workspaces/$(TF_WORKSPACE_PREFIX)-$$i  -H "Authorization: Bearer $(TF_TOKEN)" -H 'Content-Type: application/vnd.api+json'  -d '{ "data": { "attributes": { "operations": false } } }'; \
    done
