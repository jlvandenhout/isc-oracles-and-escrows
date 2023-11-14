# ISC Oracles and Escrows

Let's say you want to buy something which has to be sent to you by the seller through a parcel service, but you are faced with a choice: you either pay before the parcel is sent or you pay after the parcel is delivered. If you pay beforehand, you have to trust the seller. If you pay afterwards, the seller has to trust you.

Trying to resolve this situation, you come up with a third option: you give your money to the parcel service and the parcel service gives the money to the seller once they delivered the parcel to you, making the parcel service act as an [escrow](https://en.wikipedia.org/wiki/Escrow). While this removes the need for you and the seller to trust each other, it adds a new problem: now both of you have to trust the parcel service. You are looking for a solution that removes this trust requirement.

In this tutorial we will explore one of those solutions by utilizing [IOTA smart contracts](https://wiki.iota.org/learn/smart-contracts/introduction/) to create a trustless escrow that allows deposit and withdrawal of tokens, depending on the status of the parcel.

You will learn:

- How to develop, test, and deploy smart contracts using [Hardhat](https://hardhat.org/) on the [ShimmerEVM testnet](https://wiki.iota.org/build/networks-endpoints/#testnet-evm).
- How to send tokens between addresses on the [testnet](https://wiki.iota.org/build/networks-endpoints/#public-testnet) and smart contracts on the ShimmerEVM testnet using the [Firefly Shimmer wallet](https://firefly.iota.org/) and the [magic contract](https://wiki.iota.org/wasp-evm/getting-started/compatibility/#the-magic-contract).
- What oracle smart contracts are and why they are needed.
- How smart contracts can interact with each other.

You should already be able to:

- Understand the basics of [IOTA smart contracts](https://wiki.iota.org/learn/smart-contracts/introduction/).
- Write code in [Solidity](https://soliditylang.org/).
- Write code in [Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript).
- Use [npm](https://docs.npmjs.com/about-npm).

You will require:

- [Node.js](https://nodejs.org/en/) version `16.0` or greater.
- A code editor ([Visual Studio Code](https://code.visualstudio.com/) with the [Hardhat](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity) extension is recommended).
- A Firefly Shimmer account connected to the testnet containing a wallet with tokens for the parcel service, the buyer, and the seller. You can request tokens from the [faucet](https://faucet.testnet.shimmer.network/).

## Design Considerations

Smart contracts are triggered by requests, which means in our case we can't let our escrow smart contract listen for events like parcel status updates. We rather act on requests, like the seller wanting to withdraw tokens, and then query for the status of the parcel to see if the request is valid or if it needs to be reverted.

Additionally, smart contract execution has to be deterministic to be able to reach [concensus](https://wiki.iota.org/learn/smart-contracts/consensus/) about the outcome. This means we can't query something like a web service for parcel status updates from our escrow smart contract, because the outcome might be different for each node in the chain committee depending on the exact moment they query for it. To solve this issue, we need what is called an oracle smart contract, or simply an oracle. An oracle is a smart contract with the purpose of posting off-chain data on the chain, so it can be used as input for other smart contracts. The parcel service will use such an oracle to post status updates on the chain, which our escrow smart contract can then query, resulting in a deterministic order of updates and queries and thus a deterministic outcome.

## Set up the environment

We will use the Hardhat tool and libraries to develop, test, and deploy our contracts. So first install Hardhat and the Hardhat toolbox:

```
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
```

Initialize Hardhat with an empty configuration file:

```
npx hardhat init
```

Add the toolbox plugin to the Hardhat configuration:

```diff
+ require("@nomicfoundation/hardhat-toolbox");
+
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
};
```
