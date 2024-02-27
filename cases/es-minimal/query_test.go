package esminimal_test

import (
	"path"
	"runtime"
	"testing"
	"time"

	"github.com/hanahmily/banyandb-stress-test-aws/pkg/metrics"
)

func TestQuery(t *testing.T) {

	_, basePath, _, _ := runtime.Caller(0)
	basePath = path.Dir(basePath)
	t.Run("ServiceList", func(t *testing.T) {
		t.Parallel()
		metrics.ServiceList(basePath, 10*time.Second)
	})

}
