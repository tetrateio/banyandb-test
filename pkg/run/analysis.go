package run

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
	"strconv"

	"github.com/montanaflynn/stats"
)

func Analyze(metricNames []string, rootPath string) {
	file, err := os.Open(filepath.Join(rootPath, metricsFile))
	if err != nil {
		fmt.Println("Error opening metrics file:", err)
		return
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		fmt.Println("Error reading metrics file:", err)
		return
	}
	if reader == nil {
		fmt.Println("No records found in metrics file.")
		return
	}

	// Transpose the records to handle column-based data.
	transposed := transpose(records)

	// Open the results file.
	resultsFile, err := os.OpenFile(filepath.Join(rootPath, resultFile), os.O_CREATE|os.O_WRONLY, 0o644)
	if err != nil {
		fmt.Println("Error opening results file:", err)
		return
	}
	defer resultsFile.Close()
	if err = resultsFile.Truncate(0); err != nil {
		fmt.Println("Error truncating results file:", err)
		return
	}
	// Write the header to the results file.
	writeHeader(resultsFile)

	for i, record := range transposed {
		// Convert the records to a slice of floats for analysis.
		data := make([]float64, 0, len(record))
		for _, r := range record {
			d := atof(r) // Convert the string to a float.
			if d < 0 {
				continue
			}
			data = append(data, d)
		}

		// Calculate the statistics.
		min, _ := stats.Min(data)
		max, _ := stats.Max(data)
		mean, _ := stats.Mean(data)
		median, _ := stats.Median(data)
		p95, _ := stats.Percentile(data, 95)

		// Write the results to another file and print them to the console.
		writeResults(resultsFile, metricNames[i], min, max, mean, median, p95)
	}
}

func writeHeader(file *os.File) {
	header := "Metric Name, Min, Max, Mean, Median, P95\n"
	_, err := file.WriteString(header)
	if err != nil {
		fmt.Println("Error writing to results file:", err)
		return
	}
}

func writeResults(file *os.File, metricName string, min, max, mean, median, p95 float64) {
	results := fmt.Sprintf("%s, %f, %f, %f, %f, %f\n",
		metricName, min, max, mean, median, p95)

	_, err := file.WriteString(results)
	if err != nil {
		fmt.Println("Error writing to results file:", err)
		return
	}

	fmt.Print(results)
}

func transpose(slice [][]string) [][]string {
	xl := len(slice[0])
	yl := len(slice)
	result := make([][]string, xl)
	for i := range result {
		result[i] = make([]string, yl)
	}
	for i, row := range slice {
		for j, col := range row {
			result[j][i] = col
		}
	}
	return result
}

func atof(s string) float64 {
	value, err := strconv.ParseFloat(s, 64)
	if err != nil {
		panic(err)
	}
	return value
}
