const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Oracle", function () {
  it("Should return correct parcel ID", async function () {
    const oracle = await ethers.deployContract("Oracle");

    let id1 = await oracle.request(ethers.encodeBytes32String("NONCE1"));
    let id2 = await oracle.request(ethers.encodeBytes32String("NONCE2"));
    expect(id1).to.not.equal(id2);
  });
});
