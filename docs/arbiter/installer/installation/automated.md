# Automated Setup

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Arbiter repository](https://github.com/verdikta/verdikta-arbiter) for the latest automated setup instructions.

## Overview

The automated setup provides a one-command installation process for Verdikta Arbiter nodes.

## Quick Setup

```bash
curl -sSL https://docs.verdikta.org/install.sh | bash
```

## What the Installer Does

1. **System Check**: Verifies prerequisites
2. **Component Download**: Downloads all necessary components
3. **Configuration**: Interactive setup of API keys and settings
4. **Service Installation**: Installs and configures all services
5. **Registration**: Optionally registers with dispatcher contracts

## Interactive Configuration

The installer will prompt for:
- AI service API keys
- Blockchain RPC endpoints
- IPFS service credentials
- Wallet configuration

## Next Steps

After installation:
- [Verify installation](../management/status.md)
- [Monitor your node](../management/index.md) 