# Starting Services

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Arbiter repository](https://github.com/verdikta/verdikta-arbiter) for the latest service management instructions.

## Starting Your Arbiter Node

### Quick Start
```bash
cd ~/verdikta-arbiter-node
./start-arbiter.sh
```

### Service Startup Order

1. **AI Node Service** - Starts first
2. **External Adapter** - Connects to AI service
3. **Chainlink Node** - Last to start

### Verification

Check that all services are running:
```bash
./arbiter-status.sh
```

Expected output:
```
✅ AI Node Service: Running (Port 3000)
✅ External Adapter: Running (Port 8080)
✅ Chainlink Node: Running (Port 6688)
```

## Troubleshooting Startup Issues

If services fail to start:
1. Check the [troubleshooting guide](../troubleshooting/index.md)
2. Review service logs
3. Verify configuration files 