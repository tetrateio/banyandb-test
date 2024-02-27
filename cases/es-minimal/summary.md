# Summary of the case

## OAP

### Resource Usage

CPU and Memory usage are stable.

### Persistency Latency

1. No Query Load: ~2.5s
1. With Query Load: From 4.5s to 7s

### Query Latency

1. 5 service list, each queries 5 metrics: ~0.4s
2. 5 service query top 5 instance of throughput and latency: ~0.17s

### Console

There are some WARN errors in the log. They mean Elasticsearch server is overloaded and is closing some connections to reduce load. But it's not a critical issue since only a few connections are closed.

```bash
2024-02-27 06:21:55,465 org.apache.skywalking.library.elasticsearch.ElasticSearch 95 [armeria-eventloop-epoll-8-1] WARN  [] - [creqId=6670c54e, preqId=7583d │
│ 2024-02-27 06:21:55,465 org.apache.skywalking.library.elasticsearch.ElasticSearch 156 [armeria-eventloop-epoll-8-1] WARN  [] - [creqId=6670c54e, preqId=7583 │
│ com.linecorp.armeria.client.UnprocessedRequestException: com.linecorp.armeria.client.GoAwayReceivedException                                                 │
│ Caused by: com.linecorp.armeria.client.GoAwayReceivedException                                                                                               │
│ 2024-02-27 06:21:55,465 org.apache.skywalking.library.elasticsearch.ElasticSearch 95 [armeria-eventloop-epoll-8-1] WARN  [] - [creqId=2a78a6d3, preqId=8b584 │
│ 2024-02-27 06:21:55,465 org.apache.skywalking.library.elasticsearch.ElasticSearch 156 [armeria-eventloop-epoll-8-1] WARN  [] - [creqId=2a78a6d3, preqId=8b58 │
│ com.linecorp.armeria.client.UnprocessedRequestException: com.linecorp.armeria.client.GoAwayReceivedException                                                 │
│ Caused by: com.linecorp.armeria.client.GoAwayReceivedException                                                                                               │
│ 2024-02-27 06:21:55,465 org.apache.skywalking.library.elasticsearch.ElasticSearch 95 [armeria-eventloop-epoll-8-1] WARN  [] - [creqId=4432fa1e, preqId=3e24e │
│ 2024-02-27 06:21:55,466 org.apache.skywalking.library.elasticsearch.ElasticSearch 156 [armeria-eventloop-epoll-8-1] WARN  [] - [creqId=4432fa1e, preqId=3e24 │
│ com.linecorp.armeria.client.UnprocessedRequestException: com.linecorp.armeria.client.GoAwayReceivedException                                                 │
│ Caused by: com.linecorp.armeria.client.GoAwayReceivedException
```

## Elasticsearch

### Resource Usage

CPU: 2 Cores
        Min: 46%, Max: 97%, Avg: 65.6%

Memory: 16GB
        Min:2.27GB, Max: 7.78GB, Avg: 4.2GB

Elasticsearch will use less memory when traffic is up.

Disk: 50GB
    Read IOPS: 0
    Write IOPS: 9, Throughput: 1.3MB/s, Latency: 3ms

> [IO Metrics](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html)

### Throughput

IndexingRate: 90k/min

IndexingLatency: 0.2ms

SearchRate: 960/min

SearchLatency: 2.8ms
