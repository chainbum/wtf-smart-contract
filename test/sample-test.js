const { expect } = require("chai");
const { ethers } = require("hardhat");

/*

### Features ###

- WhiteList functionality
  - setIsWhiteListSaleActive §
  - getIsWhiteListSaleActive §
  - setWhiteList             §
  - getNumAvailableToMint    §
  - mintWhiteList

- Public mint functionality
  - setIsPublicSaleActive
  - getIsPublicSaleActive
  - mintPublic

- Reveal functionality
  - setRevealed

- Reserve
  - reserve

- Withdraw
  - withdraw

- token uri
  - tokenURI

- Misc
  - setPrice

*/



describe("WhiteList - On/Off", function () {
  it("Should check its deactivated then activate WhiteList sale ", async function () {
    const WebTimeFolks = await hre.ethers.getContractFactory("WebTimeFolks");
    const wtf = await WebTimeFolks.deploy("ipfs://QmczJSS5DWWHUtLHEzgkTKDy3ie6ryN6RzGyB1zHqTXkko/", "ipfs://QmZxKNk16sGX9ydRvwZP2aMxFV9yKAwYz9YbRgiDL6PFa3/hidden.json");
    await wtf.deployed();

    expect(await wtf.getIsWhiteListSaleActive()).to.equal(false);

    const txn = await wtf.setIsWhiteListSaleActive(true);
    await txn.wait();

    expect(await wtf.getIsWhiteListSaleActive()).to.equal(true);

  })
})

describe("WhiteList - setWhiteList", function () {
  it("Should  ", async function () {
    const WebTimeFolks = await hre.ethers.getContractFactory("WebTimeFolks");
    const wtf = await WebTimeFolks.deploy("ipfs://QmczJSS5DWWHUtLHEzgkTKDy3ie6ryN6RzGyB1zHqTXkko/", "ipfs://QmZxKNk16sGX9ydRvwZP2aMxFV9yKAwYz9YbRgiDL6PFa3/hidden.json");
    await wtf.deployed();

    const txn = await wtf.setWhiteList(['0x2ad85B6FF7B0D9fd9c1858cEeFC9119160856270'], 5);
    await txn.wait();

    expect(await wtf.getNumAvailableToMint('0x2ad85B6FF7B0D9fd9c1858cEeFC9119160856270')).to.equal(5);

  })
})