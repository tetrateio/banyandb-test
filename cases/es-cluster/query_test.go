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

func TestQuery1(t *testing.T) {
	fs := flag.NewFlagSet("", flag.PanicOnError)
	fs.String("base-url", "http://localhost:12801/graphql", "")
	_, basePath, _, _ := runtime.Caller(0)
	basePath = path.Dir(basePath)
	basePath = path.Join(basePath, "c1")
	t.Run("ServiceList", func(t *testing.T) {
		t.Parallel()
		metrics.ServiceList(basePath, timeout, 32, fs)
	})
	t.Run("TopN", func(t *testing.T) {
		t.Parallel()
		metrics.TopN(basePath, timeout, 32, fs)
	})

}

func TestQuery2(t *testing.T) {
	fs := flag.NewFlagSet("", flag.PanicOnError)
	fs.String("base-url", "http://localhost:12802/graphql", "")
	_, basePath, _, _ := runtime.Caller(0)
	basePath = path.Dir(basePath)
	basePath = path.Join(basePath, "c2")
	t.Run("ServiceList", func(t *testing.T) {
		t.Parallel()
		metrics.ServiceList(basePath, timeout, 32, fs)
	})
	t.Run("TopN", func(t *testing.T) {
		t.Parallel()
		metrics.TopN(basePath, timeout, 32, fs)
	})

}
