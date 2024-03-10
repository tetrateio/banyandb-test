# Summary of the case

## OAP

### Resource Usage

CPU and Memory usage are stable.

### Persistency Latency

1. No Query Load: ~5s
1. With Query Load: From 9 to 10s

### Query Latency

1. 32 service list, each queries 5 metrics: ~0.45s
2. 32 service query top 5 instance of throughput and latency: ~0.2s

## Elasticsearch

### Resource Usage

Data node: CPU: 4 Cores Memory: 32GB
Master node: CPU: 4 Cores Memory: 16GB

2 of 3 data nodes are busy.

Busy data node:
        CPU: ~80% Memory: 40%
Idle data node:
        CPU: ~40% Memory: 60%

Master node: CPU: ~20%

Elasticsearch will use less memory when the data node is busy.

Disk: 50GB
    Read IOPS: 0
    Write IOPS: 30, Throughput: 5MB/s, Latency: 0.003ms

> [IO Metrics](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html)

### Throughput

IndexingRate: 90k/min

IndexingLatency: 0.2ms

SearchRate: 960/min

SearchLatency: 2.8ms
