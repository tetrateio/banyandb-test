mk_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mk_dir  := $(dir $(mk_path))
root_dir := $(abspath $(mk_dir)/../..)

%-plan %-deploy %-undeploy:
	make -C $(root_dir)/infra/$* $(subst $*-,, $@) $(mk_dir)vars-$*.json

%-try %-up %-down %-wipe:
	make -C $(root_dir)/traffic-load/$* $(subst $*-,, $@) $(mk_dir)vars-$*.json
