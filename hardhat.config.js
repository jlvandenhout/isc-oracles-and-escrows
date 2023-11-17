require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  defaultNetwork: "testnet",
  networks: {
    testnet: {
      url: "https://json-rpc.evm.testnet.shimmer.network",
      from: "0x12c29a589d0d42052e9b15a9ab12b7291010bac2",
      accounts: {
        mnemonic:
          "life wonder high battle crunch monkey unique bid peasant pyramid where devote patch fit bench wood submit scan tobacco weekend van siege habit trash",
      },
    },
  },
};
