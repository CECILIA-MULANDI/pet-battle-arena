const { ethers } = require("hardhat");

async function main() {
  console.log("🐾 Deploying Pet Battle Arena to Base Sepolia...");
  
  const PetBattleArena = await ethers.getContractFactory("PetBattleArena");
  const petBattleArena = await PetBattleArena.deploy();
  
  await petBattleArena.waitForDeployment();
  
  const contractAddress = await petBattleArena.getAddress();
  console.log("🎮 Pet Battle Arena deployed to:", contractAddress);
  console.log("🔗 View on BaseScan:", `https://sepolia.basescan.org/address/${contractAddress}`);
  
  // Create some initial pets for testing
  console.log("\n🐱 Creating initial battle pets...");
  
  const tx1 = await petBattleArena.createPet("Flamewyrm", 0); // Fire
  await tx1.wait();
  console.log("🔥 Created Fire pet: Flamewyrm");
  
  const tx2 = await petBattleArena.createPet("Aquadragon", 1); // Water
  await tx2.wait();
  console.log("💧 Created Water pet: Aquadragon");
  
  const tx3 = await petBattleArena.createPet("Earthbeast", 2); // Earth
  await tx3.wait();
  console.log("🌍 Created Earth pet: Earthbeast");
  
  console.log("\n✅ Deployment completed successfully!");
  console.log("🎯 Ready for epic pet battles on Base Sepolia!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });

// Additional deployment utilities
async function verifyContract(contractAddress, constructorArgs) {
  console.log('🔍 Verifying contract on BaseScan...');
  try {
    await hre.run('verify:verify', {
      address: contractAddress,
      constructorArguments: constructorArgs,
    });
    console.log('✅ Contract verified successfully!');
  } catch (error) {
    console.log('❌ Verification failed:', error.message);
  }
}
// Deployment optimization: 5
// Deployment optimization: 15
// Deployment optimization: 25
