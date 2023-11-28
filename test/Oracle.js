const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Oracle", function () {
  it("Should return correct parcel ID", async function () {
    const [owner, user] = await ethers.getSigners();

    await owner.sendTransaction({
      to: await user.getAddress(),
      value: ethers.parseEther("1"),
    });

    const oracle = await ethers.deployContract("Oracle");
    await oracle.waitForDeployment();

    const index = ethers.getBytes(0);
    expect(await oracle.get(0)).to.equal(0);
    expect(await oracle.connect(user).set(index, 1)).to.be.reverted();
    expect(await oracle.connect(owner).set(index, 1)).to.not.be.reverted();
    expect(await oracle.connect(user).get(index)).to.equal(1);
  });
});
