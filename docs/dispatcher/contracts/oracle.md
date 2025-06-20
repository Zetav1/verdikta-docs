# Oracle Registry

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Dispatcher repository](https://github.com/verdikta/verdikta-dispatcher) for the latest oracle documentation.

## Overview

The Oracle Registry manages arbiter nodes and their integration with the Verdikta smart contracts.

## Oracle Registration

### Registration Process
```solidity
function registerOracle(
    address oracleAddress,
    string memory endpoint,
    uint256 stake
) external {
    require(stake >= MIN_ORACLE_STAKE, "Insufficient stake");
    require(!oracles[oracleAddress].isRegistered, "Already registered");
    
    vdkToken.transferFrom(msg.sender, address(this), stake);
    
    oracles[oracleAddress] = Oracle({
        owner: msg.sender,
        endpoint: endpoint,
        stake: stake,
        reputation: INITIAL_REPUTATION,
        isActive: true,
        isRegistered: true,
        totalDisputes: 0,
        successfulDisputes: 0
    });
    
    emit OracleRegistered(oracleAddress, msg.sender, stake);
}
```

### Oracle Requirements
- **Minimum Stake**: 10,000 VDK
- **Uptime**: 99%+ availability required
- **Response Time**: <5 minutes for dispute processing
- **Accuracy**: 90%+ success rate maintained

## Reputation System

### Reputation Calculation
```solidity
function updateReputation(address oracle, bool wasSuccessful) internal {
    Oracle storage orc = oracles[oracle];
    orc.totalDisputes++;
    
    if (wasSuccessful) {
        orc.successfulDisputes++;
    }
    
    // Calculate success rate
    uint256 successRate = (orc.successfulDisputes * 100) / orc.totalDisputes;
    
    // Update reputation based on performance
    if (successRate >= 95) {
        orc.reputation = min(orc.reputation + 10, MAX_REPUTATION);
    } else if (successRate < 80) {
        orc.reputation = max(orc.reputation - 20, MIN_REPUTATION);
    }
}
```

### Reputation Tiers
| Reputation | Tier | Selection Weight | Reward Multiplier |
|------------|------|------------------|-------------------|
| 0-199 | Novice | 1x | 0.8x |
| 200-399 | Bronze | 2x | 1.0x |
| 400-599 | Silver | 3x | 1.2x |
| 600-799 | Gold | 4x | 1.5x |
| 800-1000 | Platinum | 5x | 2.0x |

## Oracle Selection

### Selection Algorithm
```solidity
function selectOracles(uint256 disputeId, uint256 category) internal {
    Oracle[] memory eligibleOracles = getEligibleOracles(category);
    
    // Weight by reputation and stake
    uint256[] memory weights = new uint256[](eligibleOracles.length);
    uint256 totalWeight = 0;
    
    for (uint i = 0; i < eligibleOracles.length; i++) {
        weights[i] = eligibleOracles[i].reputation * eligibleOracles[i].stake;
        totalWeight += weights[i];
    }
    
    // Select oracles using weighted random selection
    address[] memory selected = new address[](ORACLES_PER_DISPUTE);
    for (uint i = 0; i < ORACLES_PER_DISPUTE; i++) {
        selected[i] = weightedRandomSelect(eligibleOracles, weights, totalWeight);
    }
    
    disputes[disputeId].assignedOracles = selected;
}
```

### Selection Criteria
- **Availability**: Oracle must be online and available
- **Specialization**: Preference for category-specific experience
- **Reputation**: Higher reputation increases selection probability
- **Stake Amount**: Larger stakes increase selection weight
- **Cooldown**: Recent participants have reduced selection probability

## Performance Monitoring

### Key Metrics
```solidity
struct OracleMetrics {
    uint256 totalResponses;
    uint256 averageResponseTime;
    uint256 accuracyScore;
    uint256 uptimePercentage;
    uint256 lastActiveTimestamp;
}
```

### Performance Thresholds
- **Response Time**: Must respond within 300 seconds
- **Accuracy**: Minimum 85% accuracy over 30-day period
- **Uptime**: Minimum 95% availability over 7-day period
- **Participation**: Must participate in disputes regularly

## Slashing Conditions

### Automatic Slashing
```solidity
function slashOracle(address oracle, uint256 amount, string memory reason) internal {
    require(oracles[oracle].stake >= amount, "Insufficient stake");
    
    oracles[oracle].stake -= amount;
    slashedAmounts[oracle] += amount;
    
    // Burn slashed tokens
    vdkToken.burn(amount);
    
    emit OracleSlashed(oracle, amount, reason);
}
```

### Slashing Events
- **Non-response**: 5% of stake for missing dispute
- **Invalid Response**: 10% of stake for malformed responses
- **Collusion**: 50% of stake for provable collusion
- **Extended Downtime**: 1% of stake per day offline

## Oracle Integration

### Setting Up Oracle Node
```bash
# Register oracle with smart contract
verdikta-cli oracle register \
    --stake 10000 \
    --endpoint https://your-oracle.com/api \
    --private-key your-private-key
```

### Oracle Response Format
```typescript
interface OracleResponse {
    disputeId: number;
    decision: 'plaintiff' | 'defendant' | 'split';
    confidence: number; // 0-100
    justification: string;
    timestamp: number;
    signature: string;
}
```

### Monitoring Oracle Performance
```typescript
async function getOracleMetrics(oracleAddress: string) {
    const registry = new ethers.Contract(REGISTRY_ADDRESS, REGISTRY_ABI, provider);
    
    const oracle = await registry.getOracle(oracleAddress);
    const metrics = await registry.getOracleMetrics(oracleAddress);
    
    return {
        reputation: oracle.reputation,
        stake: ethers.formatEther(oracle.stake),
        successRate: (oracle.successfulDisputes / oracle.totalDisputes) * 100,
        ...metrics
    };
}
``` 