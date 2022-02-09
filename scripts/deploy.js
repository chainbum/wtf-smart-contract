const hre = require("hardhat");

async function main() {

  const WebTimeFolks = await hre.ethers.getContractFactory("WebTimeFolks");
  const wtf = await WebTimeFolks.deploy("ipfs://QmczJSS5DWWHUtLHEzgkTKDy3ie6ryN6RzGyB1zHqTXkko/", "ipfs://QmZxKNk16sGX9ydRvwZP2aMxFV9yKAwYz9YbRgiDL6PFa3/hidden.json");

  await wtf.deployed();

  console.log("WTF deployed to:", wtf.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
