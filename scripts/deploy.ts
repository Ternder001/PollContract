import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying VotingFactory with the account:", deployer.address);

  const VotingFactory = await ethers.getContractFactory("VotingFactory");
  const votingFactory = await VotingFactory.deploy();

  await votingFactory.waitForDeployment();

  console.log("VotingFactory deployed to:", votingFactory.target);

  // Creating a new poll using the factory
  const question = "What is your favorite color?";
  const options = ["Red", "Green", "Blue"]; // Example options

  await votingFactory.createPoll(question, options);

  console.log("New poll created!");

  // Retrieve all polls created by the factory
  const polls = await votingFactory.getPolls();

  console.log("All polls created:", polls);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

