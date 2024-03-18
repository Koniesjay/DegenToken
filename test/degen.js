const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("DegenGamingToken", function () {
  let DGTContract;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    const DGTToken = await ethers.getContractFactory("DegenGamingToken");
    DGTContract = await DGTToken.connect(owner).deploy();
    await DGTContract.deployed();
  });

  it("Should mint tokens to the owner", async function () {
    await DGTContract.connect(owner).mint();
    expect(await DGTContract.balanceOf(owner.address)).to.equal(
      ethers.utils.parseEther("1")
    );
  });

  it("Should allow players to participate in the bet", async function () {
    await DGTContract.connect(addr1).bet({
      value: ethers.utils.parseEther("1"),
    });
    expect(await DGTContract.ListOfPlayers(0)).to.equal(addr1.address);
  });

  it("Should add items to the store", async function () {
    await DGTContract.connect(owner).addToStore(
      "Item1",
      ethers.utils.parseEther("1")
    );
    let cn = await DGTContract.connect(owner).storeItems(1);
    expect(cn[2]).to.equal("Item1");
  });

  it("Should burn tokens", async function () {
    await DGTContract.connect(owner).mint();
    await DGTContract.connect(owner).burn(ethers.utils.parseEther("1"));
    expect(await DGTContract.balanceOf(owner.address)).to.equal(0);
  });

  it("Should allow redemption of store items", async function () {
    await DGTContract.connect(owner).mint();
    await DGTContract.connect(owner).addToStore(
      "Item1",
      ethers.utils.parseEther("1")
    );
    await DGTContract.connect(owner).transfer(
      addr1.address,
      ethers.utils.parseEther("1")
    );
    await DGTContract.connect(addr1).approve(
      DGTContract.address,
      ethers.utils.parseEther("1")
    );
    setTimeout(async () => {
      await DGTContract.connect(addr1).redeem(1);
    }, 1000);
    setTimeout(async () => {
      expect(await DGTContract.balanceOf(addr1.address)).to.equal(0);
    }, 1000);
  });
});
