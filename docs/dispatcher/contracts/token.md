# Token & Staking

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Dispatcher repository](https://github.com/verdikta/verdikta-dispatcher) for the latest token documentation.

## Overview

The Verdikta Token (VDK) is the native utility token for the Verdikta ecosystem, used for staking, fees, and governance.

## Token Details

### VDK Token
- **Name**: Verdikta Token
- **Symbol**: VDK
- **Decimals**: 18
- **Total Supply**: 1,000,000,000 VDK
- **Contract**: ERC-20 standard

### Token Distribution
- **Community Rewards**: 40%
- **Team & Advisors**: 20%
- **Ecosystem Development**: 20%
- **Treasury**: 15%
- **Public Sale**: 5%

## Staking System

### Arbiter Staking
```solidity
function stakeAsArbiter(uint256 amount) external {
    require(amount >= MIN_STAKE, "Insufficient stake");
    vdkToken.transferFrom(msg.sender, address(this), amount);
    
    arbiters[msg.sender].stakedAmount += amount;
    arbiters[msg.sender].isActive = true;
    
    emit ArbiterStaked(msg.sender, amount);
}
```

### Unstaking Process
```solidity
function unstake(uint256 amount) external {
    require(arbiters[msg.sender].stakedAmount >= amount, "Insufficient stake");
    require(!arbiters[msg.sender].hasActiveDisputes, "Active disputes pending");
    
    arbiters[msg.sender].stakedAmount -= amount;
    
    // 7-day unbonding period
    unbondingRequests[msg.sender] = UnbondingRequest({
        amount: amount,
        unlockTime: block.timestamp + UNBONDING_PERIOD
    });
    
    emit UnstakeRequested(msg.sender, amount);
}
```

## Fee Structure

### Dispute Fees
| Dispute Value | Fee Rate | Minimum Fee |
|---------------|----------|-------------|
| $0 - $100 | 5% | 1 VDK |
| $100 - $1,000 | 3% | 5 VDK |
| $1,000 - $10,000 | 2% | 30 VDK |
| $10,000+ | 1% | 200 VDK |

### Arbiter Rewards
- **Base Reward**: 60% of dispute fee
- **Performance Bonus**: Up to 40% based on accuracy
- **Reputation Multiplier**: 1.0x - 2.0x based on standing

## Governance

### Voting Power
- 1 VDK = 1 vote
- Staked tokens have 2x voting weight
- Minimum 1,000 VDK to create proposals

### Proposal Types
- Fee rate adjustments
- Staking parameter changes
- Contract upgrades
- Treasury allocations

## Token Economics

### Inflationary Mechanisms
- **Staking Rewards**: 5% annual inflation
- **Ecosystem Incentives**: 2% annual allocation
- **Security Budget**: 1% for audits and security

### Deflationary Mechanisms
- **Fee Burns**: 50% of all fees burned
- **Slashing**: Misbehaving arbiters' stakes burned
- **Buyback Program**: Treasury buybacks and burns

## Integration Examples

### Staking VDK
```typescript
async function stakeVDK(amount: string) {
    const vdkToken = new ethers.Contract(VDK_ADDRESS, VDK_ABI, signer);
    const tokenManager = new ethers.Contract(TOKEN_MANAGER_ADDRESS, TOKEN_MANAGER_ABI, signer);
    
    // Approve tokens
    await vdkToken.approve(TOKEN_MANAGER_ADDRESS, ethers.parseEther(amount));
    
    // Stake tokens
    await tokenManager.stakeAsArbiter(ethers.parseEther(amount));
}
```

### Checking Rewards
```typescript
async function getRewards(arbiterAddress: string) {
    const tokenManager = new ethers.Contract(TOKEN_MANAGER_ADDRESS, TOKEN_MANAGER_ABI, provider);
    
    const rewards = await tokenManager.getClaimableRewards(arbiterAddress);
    return ethers.formatEther(rewards);
}
```

## Mainnet Launch

### Token Generation Event
- **Date**: Q2 2025 (planned)
- **Initial Price**: TBD
- **Liquidity**: DEX listing on Base
- **Vesting**: Linear vesting for team allocations

### Migration from Testnet
- Testnet VDK tokens are not transferable to mainnet
- New token distribution upon mainnet launch
- Early participants receive mainnet allocations 