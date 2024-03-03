package bydbminimal_test

import (
	"path"
	"runtime"
	"testing"
	"time"

	"github.com/hanahmily/banyandb-stress-test-aws/pkg/metrics"
)

const timeout = 30 * time.Minute

func TestQuery(t *testing.T) {

	_, basePath, _, _ := runtime.Caller(0)
	basePath = path.Dir(basePath)
	t.Run("ServiceList", func(t *testing.T) {
		t.Parallel()
		metrics.ServiceList(basePath, timeout)
	})
	t.Run("TopN", func(t *testing.T) {
		t.Parallel()
		metrics.TopN(basePath, timeout)
	})

}
