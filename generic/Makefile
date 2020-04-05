TERRAFORM		:= /usr/bin/terraform
PLAYBOOK_FILE := playbook.yml
APP_TAG		:= $(shell git rev-parse HEAD | cut -c1-7)


# check for environment variables to replace tokens
.PHONY: terraform-setup-check
terraform-setup-check:
ifndef TF_TOKEN_CLOUD_SRE
	$(error TF_TOKEN_CLOUD_SRE is undefined)
endif

# check for environemt variables required by terraform
.PHONY: terraform-init-check
terraform-init-check:
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
endif


.PHONY: terraform-setup
terraform-setup: terraform-setup-check
	sed -i -e "s/TF_CLOUD_TOKEN/${TF_CLOUD_TOKEN}/g" *.tf
.PHONY: terraform-init
terraform-init: terraform-init-check terraform-setup
	$(TERRAFORM) init -input=false

.PHONY: terraform-plan
terraform-plan: terraform-init
	$(TERRAFORM) plan -input=false

.PHONY: terraform-apply
terraform-apply: terraform-plan
	$(TERRAFORM) apply -input=false -auto-approve

.PHONY: terraform-destroy
terraform-destroy: terraform-init
	$(TERRAFORM) destroy -input=false -auto-approve

.PHONY: setup-awsweeper-check
setup-awsweeper-check:
ifndef  AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
endif
ifndef  AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
endif
ifndef  AWSWEEPER_VERSION
	$(error AWSWEEPER_VERSION is undefined)
endif

.PHONY: setup-awsweeper
setup-awsweeper: setup-awsweeper-check
	curl -sSfL https://raw.githubusercontent.com/cloudetc/awsweeper/master/install.sh | sh -s v$(AWSWEEPER_VERSION)
	export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)
	export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)
	export AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION)

.PHONY: awsweeper
awsweeper: setup-awsweeper
	bin/awsweeper --force awsweeper/config.yml
