.PHONY: init init-backend plan apply destroy lint

init:
	terraform init

init-backend:
	terraform init -reconfigure -backend-config=backend.hcl

plan:
	terraform plan -out=tfplan

apply:
	terraform apply -auto-approve tfplan || terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve

lint:
	terraform fmt -check -recursive
	tflint