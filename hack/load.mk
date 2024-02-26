mk_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mk_dir  := $(dir $(mk_path))

ARGUMENT = $(filter-out $@,$(MAKECMDGOALS))

try:
	@bash $(mk_dir)/plan.sh $(ARGUMENT)
up:
	@bash $(mk_dir)/deploy.sh $(ARGUMENT)
down:
	@bash $(mk_dir)/undeploy.sh $(ARGUMENT)
wipe:
	@bash $(mk_dir)/wipe.sh $(ARGUMENT)

.PHONY: plan deploy undeploy
