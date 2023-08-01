// Copyright 2023 Stichting Block Foundation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


// Import the required modules from Hardhat's Ethers.js plugin
import { ethers } from "hardhat";

// The main function of the script, which performs the deployment
async function main() {
  // Fetch signer from the Ethers.js Signer object, which represents an Ethereum account
  const [deployer] = await ethers.getSigners();

  // Log the address and balance of the deployer's account
  console.log(
    "Deploying contracts with the account:",
    await deployer.getAddress()
  );
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy TemperatureControlContract
  // Get the contract factory specific to the TemperatureControlContract
  const TemperatureControlFactory = await ethers.getContractFactory("TemperatureControlContract");
  // Use the factory to deploy a new contract instance
  const temperatureControl = await TemperatureControlFactory.deploy();
  // Wait until the contract is successfully mined and deployed
  await temperatureControl.deployed();
  // Log the address at which the contract is deployed
  console.log("TemperatureControlContract deployed to:", temperatureControl.address);

  // The steps for deploying the LightControlContract and SecurityAlertContract follow the same pattern
  const LightControlFactory = await ethers.getContractFactory("LightControlContract");
  const lightControl = await LightControlFactory.deploy();
  await lightControl.deployed();
  console.log("LightControlContract deployed to:", lightControl.address);

  const SecurityAlertFactory = await ethers.getContractFactory("SecurityAlertContract");
  const securityAlert = await SecurityAlertFactory.deploy();
  await securityAlert.deployed();
  console.log("SecurityAlertContract deployed to:", securityAlert.address);

  // Deploy the main contract (SmartHomeContract) using the deployed control contract addresses
  const SmartHomeFactory = await ethers.getContractFactory("SmartHomeContract");
  const smartHome = await SmartHomeFactory.deploy(
    "0xSomeAddress", // Address of temperature data feed
    "0xSomeAddress", // Address of light intensity data feed
    "0xSomeAddress", // Address of security alert data feed
    temperatureControl.address, // Address of the deployed TemperatureControlContract
    lightControl.address, // Address of the deployed LightControlContract
    securityAlert.address // Address of the deployed SecurityAlertContract
  );
  await smartHome.deployed();
  console.log("SmartHomeContract deployed to:", smartHome.address);
}

// Call the main function and handle any errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  