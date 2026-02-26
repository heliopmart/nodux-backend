```mermaid

graph LR
    subgraph "Domain Core"
        N{Any Domain Service} --> O[AuditPort]
    end

    subgraph "Infrastructure Adapters"
        O --> P[Async AuditAdapter]
        P --> P1[(Postgres / NoSQL)]
    end
```