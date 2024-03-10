package metrics

import (
	"flag"
	"fmt"
	"time"

	"github.com/apache/skywalking-cli/pkg/graphql/metrics"
	"github.com/apache/skywalking-cli/pkg/graphql/utils"
	"github.com/urfave/cli/v2"

	api "skywalking.apache.org/repo/goapi/query"
)

var (
	isNormal = true
)

func Execute(exp, svc, instance string, fs *flag.FlagSet) (time.Duration, error) {

	ctx := cli.NewContext(cli.NewApp(), fs, nil)
	entity := &api.Entity{
		ServiceName:         &svc,
		Normal:              &isNormal,
		ServiceInstanceName: &instance,
	}
	duration := api.Duration{
		Start: time.Now().Add(-30 * time.Minute).Format(utils.StepFormats[api.StepMinute]),
		End:   time.Now().Format(utils.StepFormats[api.StepMinute]),
		Step:  api.StepMinute,
	}
	start := time.Now()
	result, err := metrics.Execute(ctx, exp, entity, duration)
	elapsed := time.Since(start)
	if err != nil {
		return 0, err
	}
	if len(result.Results) < 1 {
		return 0, fmt.Errorf("no result")
	}
	return elapsed, nil

}

func SortMetrics(name, svc string, limit int, order api.Order, fs *flag.FlagSet) (time.Duration, error) {
	ctx := cli.NewContext(cli.NewApp(), fs, nil)
	duration := api.Duration{
		Start: time.Now().Add(-30 * time.Minute).Format(utils.StepFormats[api.StepMinute]),
		End:   time.Now().Format(utils.StepFormats[api.StepMinute]),
		Step:  api.StepMinute,
	}
	scope := api.ScopeServiceInstance
	cond := api.TopNCondition{
		Name:          name,
		ParentService: &svc,
		Normal:        &isNormal,
		Scope:         &scope,
		TopN:          limit,
		Order:         order,
	}
	start := time.Now()
	result, err := metrics.SortMetrics(ctx, cond, duration)
	elapsed := time.Since(start)
	if err != nil {
		return 0, err
	}
	if len(result) < 1 {
		return 0, fmt.Errorf("no result")
	}
	return elapsed, nil
}
