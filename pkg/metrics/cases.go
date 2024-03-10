package metrics

import (
	"flag"
	"fmt"
	"os"
	"path"
	"sync"
	"time"

	"github.com/hanahmily/banyandb-stress-test-aws/pkg/run"
	"skywalking.apache.org/repo/goapi/query"
)

func ServiceList(basePath string, timeout time.Duration, svcNum int, fs *flag.FlagSet) {
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
	size := len(metricNames) * svcNum
	header := make([]string, size)
	for k, mName := range metricNames {
		for i := 0; i < svcNum; i++ {
			offset := k*svcNum + i
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
				for i := 0; i < svcNum; i++ {
					offset := k*svcNum + i
					svc := fmt.Sprintf("service0-group%d-c1.test", i)
					wg.Add(1)
					go func(mName, svc string) {
						defer wg.Done()
						d, err := Execute(mName, svc, "", fs)
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

func TopN(basePath string, timeout time.Duration, svcNum int, fs *flag.FlagSet) {
	basePath = path.Join(basePath, "topn")
	err := os.MkdirAll(basePath, 0o755)
	if err != nil {
		panic(err)
	}
	stopCh := make(chan struct{})
	go func() {
		time.Sleep(timeout)
		close(stopCh)
	}()
	metricNames := []string{"service_instance_resp_time", "service_instance_cpm"}
	size := len(metricNames) * svcNum
	header := make([]string, size)
	for k, mName := range metricNames {
		for i := 0; i < svcNum; i++ {
			offset := k*svcNum + i
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
				for i := 0; i < svcNum; i++ {
					offset := k*svcNum + i
					svc := fmt.Sprintf("service0-group%d-c1.test", i)
					wg.Add(1)
					go func(mName, svc string) {
						defer wg.Done()
						d, err := SortMetrics(mName, svc, 5, query.OrderDes, fs)
						if err != nil {
							data[offset] = -1
							fmt.Printf("query metric %s %s error: %v \n", mName, svc, err)
						} else {
							data[offset] = d.Seconds()
						}
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
