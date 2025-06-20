# Status Monitoring

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Arbiter repository](https://github.com/verdikta/verdikta-arbiter) for the latest monitoring instructions.

## Checking Node Status

### Quick Status Check
```bash
./arbiter-status.sh
```

### Detailed Health Check
```bash
./arbiter-status.sh --detailed
```

## Key Metrics to Monitor

### Service Health
- All components running
- No error logs
- Proper port bindings

### Performance Metrics
- Dispute processing time
- AI model response times
- Memory and CPU usage

### Economic Metrics
- Earnings from disputes
- Reputation score
- Stake amount

## Log Files

Important log locations:
- AI Node: `~/verdikta-arbiter-node/ai-node/logs/`
- External Adapter: `~/verdikta-arbiter-node/external-adapter/logs/`
- Chainlink Node: `~/verdikta-arbiter-node/chainlink-node/logs/`

## Alerting

Set up monitoring for:
- Service downtime
- Error rate increases
- Resource exhaustion
- Network connectivity issues 