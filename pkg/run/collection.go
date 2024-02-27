package run

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
	"time"
)

const (
	metricsFile = "data.csv"
	resultFile  = "result.csv"
)

type Scrape func() ([]float64, error)

func Collect(rootPath string, scrape Scrape, interval time.Duration, closeCh <-chan struct{}) {
	file, err := os.OpenFile(filepath.Join(rootPath, metricsFile), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0o644)
	if err != nil {
		panic(err)
	}
	defer file.Close()
	if err = file.Truncate(0); err != nil {
		panic(err)
	}
	lastCollectTime := time.Now()
	for {
		metrics, err := scrape()
		if err != nil {
			fmt.Println("Error scraping metrics:", err)
			select {
			case <-closeCh:
				return
			case <-time.After(5 * time.Second):
			}
			continue
		}

		select {
		case <-closeCh:
			return
		default:
		}
		if time.Since(lastCollectTime) < time.Minute {
			select {
			case <-closeCh:
				return
			case <-time.After(interval):
			}
			continue
		}
		lastCollectTime = time.Now()

		err = writeMetrics(file, metrics)
		if err != nil {
			fmt.Println("Error writing metrics:", err)
		}
		select {
		case <-closeCh:
			return
		case <-time.After(interval):
		}
	}
}

func writeMetrics(file *os.File, metrics []float64) error {
	writer := csv.NewWriter(file)
	defer writer.Flush()

	record := make([]string, len(metrics))
	for i := range metrics {
		record[i] = fmt.Sprintf("%f", metrics[i])
	}

	return writer.Write(record)
}
