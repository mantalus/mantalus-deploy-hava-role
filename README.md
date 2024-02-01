# Mantalus Hava Read Only Role

This project aims to creates the necessary role for Hava to access and retrieve information from the AWS resources within an AWS account.

The project involves the creation of the following components:
- A customised IAM policy designed to be linked to the Hava Read Only role.
- A customised IAM role that utilises the aforementioned custom policy.

## Hava Official Documentation
The official documentation can be found here: https://docs.hava.io/getting-started/readme

## Pre-requisites
You must complete the following steps before you can start deploying:
1. Run `npm install` to install all dependencies from `package.json`.
2. To autogenerate TS interfaces from `/config` folder using `npm run prep-all`, you need to run and install the following `pip3 install yq` and `brew install jq` first.

## Make Commands

Before you can run any of the commands below, make sure you export your AWS profile with the following command `export AWS_PROFILE=<YOUR_AWS_PROFILE>`. You can create your profile by going into your `~/.aws/config` file in your `.aws` folder (HINT: You can open it using the following command `open ~/.aws` in your terminal.). If you have not set your AWS profile, you will need to run `aws configure --profile <NAME_OF_YOUR_PROFILE>` and `aws configure sso` prior to running the make commands below.

**Run `aws sso login` before running any of the commands below.**

The `ENV` variable should match the name of the file in `config` folder.

1.  `make bootstrap ENV=<mantalus-dev/mantalus-prod/etc>` to bootstrap your account with the AWS account in your local `.aws` directory.
2.  `make deploy-all ENV=<mantalus-dev/mantalus-prod/etc>` to deploy all stacks that are in `bin` directory with either prod or dev environment.
3.  `make deploy STACK_NAME=<NAME_OF_STACK> ENV=<mantalus-dev/mantalus-prod/etc>` to deploy a certain CDK stack.
4.  `make destroy-all ENV=<mantalus-dev/mantalus-prod/etc>` to destroy all stacks that are in `bin` directory.
5.  `make destroy STACK_NAME=<NAME_OF_STACK> ENV=<mantalus-dev/mantalus-prod/etc>` to destroy a certain CDK stack.
6.  `make synth STACK_NAME=<NAME_OF_STACK> ENV=<mantalus-dev/mantalus-prod/etc>` to sync all stacks that are in `bin` directory


## Post-Deployment Steps

Below are a couple of additional steps after the role has been successfully deployed in the account:
1. You need to find and copy the role ARN and use it to allow Hava to use the role.
2. Log in to your account on [Hava](https://www.hava.io/) and click on **Add Source**, which takes you to a page where you can paste the role ARN and add a name for the account. 