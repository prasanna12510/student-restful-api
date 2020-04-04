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

.PHONY: docker-login
docker-login: docker-login-check
	docker login --username $(DOCKER_USERNAME) -p $(DOCKER_TOKEN) 2>/dev/null

.PHONY: terraform-destroy-check
terraform-destroy-check:
ifndef TF_CLOUD_TOKEN
	$(error TF_TOKEN is undefined)
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
		cd $$CWD/student_service/$$TF_FILE_PATH; \
		sed -i -e "s/TF_CLOUD_TOKEN/$(TF_CLOUD_TOKEN)/g" *.tf; \
		$(TERRAFORM) init -input=false; \
		$(TERRAFORM) plan -destroy -input=false; \
		$(TERRAFORM) destroy -input=false -auto-approve; \
	done; \
	}
