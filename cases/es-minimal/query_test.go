package esminimal_test

import (
	"flag"
	"path"
	"runtime"
	"testing"
	"time"

	"github.com/hanahmily/banyandb-stress-test-aws/pkg/metrics"
)

const timeout = 30 * time.Minute

func TestQuery(t *testing.T) {
	fs := flag.NewFlagSet("", flag.PanicOnError)
	fs.String("base-url", "http://localhost:12800/graphql", "")
	_, basePath, _, _ := runtime.Caller(0)
	basePath = path.Dir(basePath)
	t.Run("ServiceList", func(t *testing.T) {
		t.Parallel()
		metrics.ServiceList(basePath, timeout, 5, fs)
	})
	t.Run("TopN", func(t *testing.T) {
		t.Parallel()
		metrics.TopN(basePath, timeout, 5, fs)
	})

}
