package metrics

import (
	"fmt"
	"os"
	"path"
	"sync"
	"time"

	"github.com/hanahmily/banyandb-stress-test-aws/pkg/run"
)

func ServiceList(basePath string, timeout time.Duration) {
	basePath = path.Join(basePath, "svc-list")
	err := os.MkdirAll(basePath, 0o755)
	if err != nil {
		panic(err)
	}
	stopCh := make(chan struct{})
	go func() {
		time.Sleep(timeout)
		close(stopCh)
	}()
	metricNames := []string{"service_sla", "service_cpm", "service_resp_time", "service_apdex", "service_sidecar_internal_req_latency_nanos"}
	size := len(metricNames) * 5
	header := make([]string, size)
	for k, mName := range metricNames {
		for i := 0; i < 5; i++ {
			offset := k*5 + i
			header[offset] = fmt.Sprintf("%s-%d", mName, i)
		}
	}
	var wg sync.WaitGroup
	wg.Add(1)
	go func() {
		defer wg.Done()
		run.Collect(basePath, func() ([]float64, error) {
			data := make([]float64, size)
			var wg sync.WaitGroup
			for k, mName := range metricNames {
				for i := 0; i < 5; i++ {
					offset := k*5 + i
					svc := fmt.Sprintf("service0-group%d-c1.test", i)
					wg.Add(1)
					go func(mName, svc string) {
						defer wg.Done()
						d, err := Execute(mName, svc, "")
						if err != nil {
							fmt.Printf("query metric %s %s error: %v \n", mName, svc, err)
						}
						data[offset] = d.Seconds()
					}(mName, svc)
				}
			}
			wg.Wait()
			return data, nil
		}, 500*time.Millisecond, stopCh)
		run.Analyze(header, basePath)
	}()
	wg.Wait()
}
