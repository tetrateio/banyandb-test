mk_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mk_dir  := $(dir $(mk_path))
root_dir := $(abspath $(mk_dir)/../..)

%-plan %-deploy %-undeploy:
	make -C $(root_dir)/infra/base $(subst $*-,, $@) $(mk_dir)vars-$*.json

%-validate:
	TF_VAR_kube_cluster=$* make -C $(root_dir)/infra/addons plan $(mk_dir)vars-addons.json
%-install:
	TF_VAR_kube_cluster=$* make -C $(root_dir)/infra/addons deploy $(mk_dir)vars-addons.json
%-uninstall:
	TF_VAR_kube_cluster=$* make -C $(root_dir)/infra/addons undeploy $(mk_dir)vars-addons.json

%-try %-up %-down %-wipe:
	TF_VAR_kube_cluster=$* make -C $(root_dir)/traffic-load/istio $(subst $*-,, $@) $(mk_dir)vars-istio.json

c1-query-test:
	go test -tags prometheus -timeout 60m -run TestQuery1 github.com/hanahmily/banyandb-stress-test-aws/cases/es-cluster

c2-query-test:
	go test -tags prometheus -timeout 60m -run TestQuery2 github.com/hanahmily/banyandb-stress-test-aws/cases/es-cluster
