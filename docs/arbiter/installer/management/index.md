# Service Management

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Arbiter repository](https://github.com/verdikta/verdikta-arbiter) for the latest management instructions.

## Overview

This section covers managing your Verdikta Arbiter node after installation.

## Daily Operations

### Starting Services
```bash
cd ~/verdikta-arbiter-node
./start-arbiter.sh
```

### Stopping Services
```bash
./stop-arbiter.sh
```

### Checking Status
```bash
./arbiter-status.sh
```

## Management Tasks

- [Starting Services](starting.md) - How to start all components
- [Monitoring Status](status.md) - Checking node health and performance
- [Updates and Maintenance](../troubleshooting/index.md) - Keeping your node updated

## Key Management Scripts

| Script | Purpose |
|--------|---------|
| `start-arbiter.sh` | Start all arbiter services |
| `stop-arbiter.sh` | Stop all services gracefully |
| `arbiter-status.sh` | Check service status |
| `register-oracle.sh` | Register with new dispatchers |

## Monitoring

Keep track of:
- Service health and uptime
- Dispute processing metrics
- Earnings and reputation
- System resource usage 