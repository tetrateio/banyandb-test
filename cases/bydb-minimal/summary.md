# Summary of the case

## OAP

### Resource Usage

CPU and Memory usage are stable.

### Persistency Latency

1. No Query Load: 10s
1. With Query Load: 10s

BanyanDB module default to 10s cache time, so the persistency latency is 10s.

### Query Latency

SSD is a bit faster than HDD. But it is more stable than HDD.

#### HDD

1. 5 service list, each queries 5 metrics: ~0.5s
2. 5 service query top 5 instance of throughput and latency: ~0.5s

### SSD

1. 5 service list, each queries 5 metrics: ~0.5s
2. 5 service query top 5 instance of throughput and latency: ~0.4s

## BanyanDB single node

### Resource Usage

CPU: 1.6 of 4 Cores

Memory: 800MB of 8GB

125GB HDD
    Read IOPS: 0
    Write IOPS: 540, Throughput: 400MB/s, Write Time: 5.19s, Queue Length: 0.086

50GB SSD
    Read IOPS: 0
    Write IOPS: 538, Throughput: 400MB/s, Write Time: 1.8s, Queue Length: 0.03

### Throughput

Write Rate: 1.6k ~2k/s

Query Rate: 30/s

Write Latency: hdd: 0.4ms ssd: 0.3ms

Query Latency: hdd: 1 ~ 2s ssd: 0.9 ~ 1.5s

SSD query stability is better than HDD.
