# Dispatcher Contract

!!! warning "Content in Development"
    This content is being migrated from the source repository. Please check the [Verdikta Dispatcher repository](https://github.com/verdikta/verdikta-dispatcher) for the latest contract documentation.

## Overview

The VerdiktaDispatcher is the main orchestration contract that manages the entire dispute resolution process.

## Contract Interface

### Core Functions

#### Create Dispute
```solidity
function createDispute(
    string memory title,
    string memory description,
    bytes32 evidenceHash,
    uint256 category
) external payable returns (uint256 disputeId)
```

#### Submit Decision
```solidity
function submitDecision(
    uint256 disputeId,
    uint8 outcome,
    string memory justification,
    bytes[] memory signatures
) external
```

#### Get Dispute
```solidity
function getDispute(uint256 disputeId) 
    external view returns (Dispute memory)
```

### Events

#### DisputeCreated
```solidity
event DisputeCreated(
    uint256 indexed disputeId,
    address indexed creator,
    bytes32 evidenceHash,
    uint256 stake
);
```

#### DisputeResolved
```solidity
event DisputeResolved(
    uint256 indexed disputeId,
    uint8 outcome,
    string justification
);
```

## Data Structures

### Dispute Struct
```solidity
struct Dispute {
    address creator;
    string title;
    string description;
    bytes32 evidenceHash;
    uint256 category;
    uint256 stake;
    uint8 status;
    uint8 outcome;
    string justification;
    uint256 createdAt;
    uint256 resolvedAt;
    address[] assignedArbiters;
}
```

### Status Enum
```solidity
enum DisputeStatus {
    Pending,      // 0 - Just created
    Assigned,     // 1 - Arbiters assigned
    Processing,   // 2 - Under review
    Resolved,     // 3 - Decision made
    Executed      // 4 - Outcome executed
}
```

## Integration Examples

### Creating a Dispute
```typescript
import { ethers } from 'ethers';

async function createDispute(
    title: string,
    description: string,
    evidenceHash: string,
    stake: string
) {
    const dispatcher = new ethers.Contract(
        DISPATCHER_ADDRESS,
        DISPATCHER_ABI,
        signer
    );
    
    const tx = await dispatcher.createDispute(
        title,
        description,
        evidenceHash,
        1, // category: ecommerce
        {
            value: ethers.parseEther(stake)
        }
    );
    
    const receipt = await tx.wait();
    const disputeId = receipt.logs[0].args.disputeId;
    
    return disputeId;
}
```

### Monitoring Disputes
```typescript
async function watchDispute(disputeId: number) {
    dispatcher.on('DisputeResolved', (id, outcome, justification) => {
        if (id.toString() === disputeId.toString()) {
            console.log('Dispute resolved:', {
                outcome,
                justification
            });
        }
    });
}
```

## Gas Optimization

### Estimated Gas Costs
| Function | Gas Cost |
|----------|----------|
| createDispute | ~150,000 |
| submitDecision | ~200,000 |
| getDispute | ~30,000 |

### Optimization Tips
- Batch operations when possible
- Use view functions for reads
- Consider gas price optimization

## Security Features

- Reentrancy protection on all state-changing functions
- Access control for administrative functions
- Input validation and sanitization
- Emergency pause capability 