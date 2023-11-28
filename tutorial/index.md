# ISC Oracles and Escrows

Let's say you want to buy something which has to be sent to you by the seller using a parcel service, but you are faced with a choice: you either pay before the parcel is sent or you pay after the parcel is delivered. If you pay beforehand, you have to trust the seller. If you pay afterwards, the seller has to trust you.

Trying to resolve this situation, you come up with a third option: you deposit money into an account of the parcel service, which will only allow the seller to withdraw the money after the parcel has been delivered, making the parcel service act as an [escrow](https://en.wikipedia.org/wiki/Escrow). While this removes the trust assumption between you and the seller, it adds another: both of you now have to trust the parcel service. You are looking for a solution that removes this trust assumption entirely.

In this tutorial we will explore one of those solutions by utilizing [IOTA smart contracts](https://wiki.iota.org/learn/smart-contracts/introduction/) to create a trustless escrow that allows deposit and withdrawal of tokens, depending on the delivery status of the parcel.

You will learn:

- How to develop, test, and deploy smart contracts using [Hardhat](https://hardhat.org/) on the [testnet EVM](https://wiki.iota.org/build/networks-endpoints/#testnet-evm).
- What oracle smart contracts are and why they are needed.
- How smart contracts can interact with each other.

You should already be able to:

- Understand the basics of [IOTA smart contracts](https://wiki.iota.org/learn/smart-contracts/introduction/).
- Use an EVM compatible wallet, like [Bloom](https://bloomwallet.io/) or [MetaMask](https://metamask.io/).
- Write code in [Solidity](https://soliditylang.org/).
- Write code in [Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript).
- Use [npm](https://docs.npmjs.com/about-npm).

You will require:

- [Node.js](https://nodejs.org/en/) version `16.0` or greater.
- A code editor. We recommend [Visual Studio Code](https://code.visualstudio.com/) with the [Hardhat extension](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity).
- A wallet with a [testnet EVM](https://wiki.iota.org/build/networks-endpoints/#testnet-evm) account holding some tokens. You can request test tokens from the [faucet](https://evm-toolkit.evm.testnet.shimmer.network/).

## Design Considerations

Smart contract execution has to be deterministic to be able to reach [concensus](https://wiki.iota.org/learn/smart-contracts/consensus/) about the outcome. This means we can't query something like a web service for parcel status updates from our escrow smart contract, because the outcome might be different for each node in the chain committee depending on the exact moment they query for it. To solve this issue, we need what is called an oracle smart contract, or simply an oracle. An oracle is a smart contract with the purpose of getting off-chain data on the chain, so it can be used as input for other smart contracts. The parcel service will use such an oracle to post status updates on the chain, which our escrow smart contract can then query, resulting in a deterministic order of updates and queries and thus a deterministic outcome.

Another thing to keep in mind is smart contracts are triggered by requests, which means in our case we can't let our escrow smart contract listen for events like parcel status updates. Generally you would solve this using a callback pattern, but in this tutorial we will simply request the parcel status from the oracle whenever we need it.

## Set up the environment

We will use Hardhat and the [Hardhat toolbox](https://www.npmjs.com/package/@nomicfoundation/hardhat-toolbox) to develop, test, and deploy our contracts and we will configure it to use the testnet EVM. So install Hardhat and the Hardhat toolbox:

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

And finally add the network configuration of the testnet EVM using the information from your wallet and set it to be the default to use:

```diff
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
+  networks: {
+    testnet: {
+      url: "https://json-rpc.evm.testnet.shimmer.network",
+      from: "<your_evm_account_address>",
+      accounts: {
+        mnemonic: "<your_account_recovery_phrase>",
+      },
+    },
+  },
};
```

## The Oracle smart contract
