.PHONY: lint bootstrap deploy diff synth deploy-all destroy

# Define variables
SRC_DIR:=lib
SRC_FILES:=$(wildcard $(SRC_DIR)/**/*.ts)
AWS_ACCOUNT_ID:=$(shell aws sts get-caller-identity --query "Account" --output text)
AWS_REGION:=ap-southeast-2
export AWS_ACCOUNT_ID

format:
	node_modules/.bin/prettier --write "**/*.ts"

lint:
	node_modules/.bin/eslint "**/*.ts"

bootstrap:
	@echo "You are currently using the following AWS ACCOUNT ID: $(AWS_ACCOUNT_ID)"
ifndef ACCOUNT
	$(error ACCOUNT is not set. Usage: make bootstrap ACCOUNT=prod/dev)
endif
	cdk bootstrap aws://$(AWS_ACCOUNT_ID)/$(AWS_REGION) -c config=$(ACCOUNT)

deploy:
ifndef STACK_NAME 
	$(error STACK_NAME is not set. Usage: make deploy STACK_NAME=<stack-name> ACCOUNT=<prod/dev> or run make deploy-all ACCOUNT=prod/dev to deploy all stacks)
endif
ifndef ACCOUNT
	$(error ACCOUNT is not set. Usage: make deploy STACK_NAME=<stack-name> ACCOUNT=<prod/dev>)
endif
	npm run prep-all
	cdk deploy $(STACK_NAME) -c config=$(ACCOUNT)

diff:
ifndef ACCOUNT
	$(error ACCOUNT is not set. Usage: make diff STACK_NAME=<stack-name> ACCOUNT=<prod/dev>)
endif
	cdk diff $(STACK_NAME) -c config=$(ACCOUNT)

synth:
ifndef ACCOUNT
	$(error ACCOUNT is not set. Usage: make synth STACK_NAME=<stack-name> ACCOUNT=<prod/dev>)
endif
	cdk synth $(STACK_NAME) -c config=$(ACCOUNT)

deploy-all:
ifndef ACCOUNT
	$(error ACCOUNT is not set. Usage: make deploy-all ACCOUNT=<prod/dev>)
endif
	cdk deploy --all -c config=$(ACCOUNT)

destroy:
ifndef STACK_NAME
	$(error STACK_NAME is not set. Usage: make destroy STACK_NAME=<stack-name> ACCOUNT=<prod/dev> or run make destroy-all ACCOUNT=prod/dev to deploy all stacks)
endif
ifndef ACCOUNT
	$(error ACCOUNT is not set. Usage: make destroy STACK_NAME=<stack-name> ACCOUNT=<prod/dev>)
endif
	cdk destroy $(STACK_NAME) -c config=$(ACCOUNT)

destroy-all:
ifndef ACCOUNT
	$(error ACCOUNT is not set. Usage: make destroy-all ACCOUNT=<prod/dev>)
endif
	cdk destroy --all -c config=$(ACCOUNT)