infra:
	@echo "Currently assumed role is:"
	rapture whoami
	terraform init
	terraform validate
	terraform apply -auto-approve -var-file=eks-testing-vars.json
destroy:
	terraform destroy -auto-approve -var-file=eks-testing-vars.json

.PHONY: infra destroy