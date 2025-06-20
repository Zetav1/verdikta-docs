# Quick Start Guide

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Arbiter repository](https://github.com/verdikta/verdikta-arbiter) for the latest quick start instructions.

## Overview

This guide gets you up and running with a Verdikta Arbiter node in under 30 minutes.

## Prerequisites Check

Before starting, ensure you have:
- [x] System requirements met
- [x] All required API keys
- [x] Wallet with sufficient funds
- [x] Docker installed

## Installation Steps

### 1. Clone Repository

```bash
git clone https://github.com/verdikta/verdikta-arbiter.git
cd verdikta-arbiter
```

### 2. Run Installer

```bash
cd installer
bash bin/install.sh
```

### 3. Configure Environment

The installer will prompt you for:
- API keys (OpenAI, Anthropic, etc.)
- Blockchain RPC endpoints
- IPFS service credentials
- Wallet private key

### 4. Start Services

```bash
cd ~/verdikta-arbiter-node
./start-arbiter.sh
```

### 5. Verify Installation

```bash
./arbiter-status.sh
```

## What's Next?

- [Register with Dispatcher](installation/automated.md)
- [Monitor Your Node](management/status.md)
- [Troubleshooting](troubleshooting/index.md)

## Support

Need help? Check our [troubleshooting guide](troubleshooting/index.md) or join our [Discord community](https://discord.gg/verdikta). 