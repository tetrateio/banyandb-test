.PHONY: format

format: install
	@find . -name "*.tf" -exec terraform fmt {} \;
	@find . -name "*.yaml" -exec yamllint -d "{extends: default, rules: {line-length: {max: 120}}}" {} \;
	go mod tidy
	go fmt ./...
	go vet ./...

.PHONY: install
install:
	@if ! (command -v terraform &> /dev/null); then \
		curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - ; \
		sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $$(lsb_release -cs) main" ; \
		sudo apt-get update && sudo apt-get install terraform ; \
	fi
	@if ! (command -v yamllint &> /dev/null); then \
		sudo apt-get install -y yamllint ; \
	fi
