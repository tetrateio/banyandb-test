mk_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mk_dir  := $(dir $(mk_path))

plan:
	bash $(mk_dir)/plan.sh
deploy:
	bash $(mk_dir)/deploy.sh
undeploy:
	bash $(mk_dir)/undeploy.sh

.PHONY: plan deploy undeploy
