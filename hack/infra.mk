mk_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mk_dir  := $(dir $(mk_path))

ARGUMENT = $(filter-out $@,$(MAKECMDGOALS))

plan:
	@bash $(mk_dir)/plan.sh $(ARGUMENT)
deploy:
	@bash $(mk_dir)/deploy.sh $(ARGUMENT)
undeploy:
	@bash $(mk_dir)/undeploy.sh $(ARGUMENT)

.PHONY: plan deploy undeploy
