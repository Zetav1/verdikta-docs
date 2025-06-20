# Deployment Guide

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Dispatcher repository](https://github.com/verdikta/verdikta-dispatcher) for the latest deployment instructions.

## Overview

This guide covers deploying the Verdikta smart contract suite to your own network or fork.

## Prerequisites

### Development Environment
- Node.js 16+
- Hardhat or Foundry
- Git

### Network Requirements
- EVM-compatible blockchain
- Sufficient native tokens for gas
- RPC endpoint access

## Deployment Scripts

### Automated Deployment
```bash
# Clone the repository
git clone https://github.com/verdikta/verdikta-dispatcher.git
cd verdikta-dispatcher

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Deploy to testnet
npx hardhat run scripts/deploy.js --network base-sepolia

# Deploy to mainnet
npx hardhat run scripts/deploy.js --network base-mainnet
```

### Manual Deployment Steps

#### 1. Deploy Core Contracts
```typescript
// Deploy VDK Token
const VDKToken = await ethers.getContractFactory("VerdiktaToken");
const vdkToken = await VDKToken.deploy(
    "Verdikta Token",
    "VDK",
    ethers.parseEther("1000000000") // 1B tokens
);

// Deploy Token Manager
const TokenManager = await ethers.getContractFactory("TokenManager");
const tokenManager = await TokenManager.deploy(vdkToken.address);

// Deploy Reputation Manager
const ReputationManager = await ethers.getContractFactory("ReputationManager");
const reputationManager = await ReputationManager.deploy();

// Deploy Dispute Factory
const DisputeFactory = await ethers.getContractFactory("DisputeFactory");
const disputeFactory = await DisputeFactory.deploy();

// Deploy Main Dispatcher
const VerdiktaDispatcher = await ethers.getContractFactory("VerdiktaDispatcher");
const dispatcher = await VerdiktaDispatcher.deploy(
    vdkToken.address,
    tokenManager.address,
    reputationManager.address,
    disputeFactory.address
);
```

#### 2. Configure Contracts
```typescript
// Set up permissions
await tokenManager.setDispatcher(dispatcher.address);
await reputationManager.setDispatcher(dispatcher.address);
await disputeFactory.setDispatcher(dispatcher.address);

// Configure parameters
await dispatcher.setMinStake(ethers.parseEther("1000")); // 1000 VDK
await dispatcher.setFeeRate(300); // 3%
await dispatcher.setOracleCount(3); // 3 oracles per dispute
```

## Configuration Parameters

### Network-Specific Settings
```typescript
const CONFIG = {
  'base-sepolia': {
    minStake: ethers.parseEther("100"), // Lower for testnet
    feeRate: 500, // 5%
    oracleCount: 1,
    unbondingPeriod: 3600 // 1 hour
  },
  'base-mainnet': {
    minStake: ethers.parseEther("10000"), // 10K VDK
    feeRate: 300, // 3%
    oracleCount: 3,
    unbondingPeriod: 604800 // 7 days
  }
};
```

### Economic Parameters
```solidity
struct EconomicParams {
    uint256 minStakeAmount;      // Minimum stake for arbiters
    uint256 feeRate;             // Fee rate in basis points
    uint256 slashingRate;        // Slashing rate for misbehavior
    uint256 rewardMultiplier;    // Reward multiplier for performance
    uint256 unbondingPeriod;     // Time to unbond stakes
}
```

## Verification

### Contract Verification
```bash
# Verify on Etherscan/Basescan
npx hardhat verify --network base-sepolia \
    <contract-address> \
    <constructor-arg1> \
    <constructor-arg2>
```

### Deployment Testing
```typescript
async function testDeployment() {
    // Test token operations
    await vdkToken.transfer(testAddress, ethers.parseEther("1000"));
    
    // Test staking
    await vdkToken.approve(tokenManager.address, ethers.parseEther("100"));
    await tokenManager.stakeAsArbiter(ethers.parseEther("100"));
    
    // Test dispute creation
    const tx = await dispatcher.createDispute(
        "Test Dispute",
        "Test Description",
        ethers.keccak256(ethers.toUtf8Bytes("evidence")),
        1, // category
        { value: ethers.parseEther("0.01") }
    );
    
    console.log("Deployment test successful!");
}
```

## Security Considerations

### Pre-Deployment Checklist
- [ ] All contracts audited
- [ ] Access controls properly configured
- [ ] Emergency pause mechanisms tested
- [ ] Upgrade paths documented
- [ ] Multi-signature wallet configured

### Post-Deployment
- [ ] Contract ownership transferred to multi-sig
- [ ] Time delays activated on critical functions
- [ ] Monitoring and alerting set up
- [ ] Emergency response plan prepared

## Mainnet Deployment

### Production Checklist
- [ ] Final security audit completed
- [ ] Testnet deployment thoroughly tested
- [ ] Economic parameters finalized
- [ ] Governance structure established
- [ ] Community coordination planned

### Launch Sequence
1. **Deploy Contracts**: Deploy all contracts with production parameters
2. **Initialize State**: Set up initial configurations and permissions
3. **Transfer Ownership**: Move control to governance contracts
4. **Enable Features**: Gradually enable features with monitoring
5. **Announce Launch**: Coordinate community announcement

## Monitoring

### Key Metrics to Track
- Contract deployment success
- Gas costs and optimization
- Function call frequencies
- Error rates and failures
- Economic parameter effectiveness

### Alerting Setup
```typescript
// Monitor critical events
dispatcher.on('DisputeCreated', (disputeId, creator, stake) => {
    console.log(`New dispute ${disputeId} created by ${creator}`);
});

dispatcher.on('OracleSlashed', (oracle, amount, reason) => {
    console.log(`Oracle ${oracle} slashed ${amount} for ${reason}`);
});
``` 