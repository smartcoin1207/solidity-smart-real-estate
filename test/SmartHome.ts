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


// Import the required modules and types for testing
import { ethers } from "hardhat";
import chai from "chai";
import { solidity } from "ethereum-waffle";


import { TemperatureControlContract } from "../typechain/TemperatureControlContract";
import { LightControlContract } from "../typechain/LightControlContract";
import { SecurityAlertContract } from "../typechain/SecurityAlertContract";
import { SmartHomeContract } from "../typechain/SmartHomeContract";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

// Use solidity testing capabilities from ethereum-waffle
chai.use(solidity);
const { expect } = chai;

// Test suite for the SmartHomeContract
describe("SmartHomeContract", function () {
  let temperatureControl: TemperatureControlContract;
  let lightControl: LightControlContract;
  let securityAlertControl: SecurityAlertContract;
  let smartHome: SmartHomeContract;
  let owner: SignerWithAddress;

  // Runs before each test in the suite, setting up contract instances for testing
  beforeEach(async function () {
    // Get contract factories for deploying instances
    const TemperatureControlFactory = await ethers.getContractFactory("TemperatureControlContract");
    const LightControlFactory = await ethers.getContractFactory("LightControlContract");
    const SecurityAlertFactory = await ethers.getContractFactory("SecurityAlertContract");
    const SmartHomeFactory = await ethers.getContractFactory("SmartHomeContract");

    [owner] = await ethers.getSigners();

    // Deploy contract instances for testing
    temperatureControl = (await TemperatureControlFactory.deploy()) as TemperatureControlContract;
    lightControl = (await LightControlFactory.deploy()) as LightControlContract;
    securityAlertControl = (await SecurityAlertFactory.deploy()) as SecurityAlertContract;
    smartHome = (await SmartHomeFactory.deploy(
        "0xSomeAddress", // temperature feed
        "0xSomeAddress", // light intensity feed
        "0xSomeAddress", // security alert feed
        temperatureControl.address,
        lightControl.address,
        securityAlertControl.address
    )) as SmartHomeContract;

    // Make sure contract was deployed successfully
    await smartHome.deployed();
  });

  // Test case: owner can update threshold values
  it("Should correctly set thresholds", async function () {
    await smartHome.setThresholdTemperature(30);
    await smartHome.setThresholdLightIntensity(600);
    await smartHome.setThresholdSecurityAlert(80);

    expect(await smartHome.thresholdTemperature()).to.equal(30);
    expect(await smartHome.thresholdLightIntensity()).to.equal(600);
    expect(await smartHome.thresholdSecurityAlert()).to.equal(80);
  });

  // Test case: non-owner cannot update threshold values
  it("Should fail when non-owner attempts to set thresholds", async function () {
    const [_, nonOwner] = await ethers.getSigners();

    await expect(
      smartHome.connect(nonOwner).setThresholdTemperature(30)
    ).to.be.revertedWith("Caller is not owner");

    await expect(
      smartHome.connect(nonOwner).setThresholdLightIntensity(600)
    ).to.be.revertedWith("Caller is not owner");

    await expect(
      smartHome.connect(nonOwner).setThresholdSecurityAlert(80)
    ).to.be.revertedWith("Caller is not owner");
  });

  // Test case: contract emits event when temperature threshold is exceeded
  it("Should emit TemperatureThresholdCrossed event when threshold is exceeded", async function () {
    // We need to have a way of controlling the data returned by temperatureFeed.latestRoundData()  
    await expect(smartHome.checkTemperature())
      .to.emit(smartHome, "TemperatureThresholdCrossed")
      .withArgs(/* expected temperature value */);
  });

  // Test case: contract emits event when light intensity threshold is exceeded
  it("Should emit LightIntensityThresholdCrossed event when threshold is exceeded", async function () {
    // We need to have control over lightIntensityFeed.latestRoundData()    
    await expect(smartHome.checkLightIntensity())
      .to.emit(smartHome, "LightIntensityThresholdCrossed")
      .withArgs(/* expected light intensity value */);
  });

  // Test case: contract emits event when security alert threshold is exceeded
  it("Should emit SecurityAlertThresholdCrossed event when threshold is exceeded", async function () {
    // We need to have control over securityAlertFeed.latestRoundData()    
    await expect(smartHome.checkSecurityAlert())
      .to.emit(smartHome, "SecurityAlertThresholdCrossed")
      .withArgs(/* expected security alert value */);
  });

  // Test case: contract correctly updates temperature in TemperatureControlContract
  it("Should set correct temperature in TemperatureControlContract", async function () {
    // Assume that temperatureFeed.latestRoundData() returns a value higher than the threshold    
    await smartHome.checkTemperature();
    expect(await temperatureControl.temperature()).to.equal(await smartHome.thresholdTemperature());
  });

  // Test case: contract correctly updates light intensity in LightControlContract
  it("Should set correct light intensity in LightControlContract", async function () {
    // Assume that lightIntensityFeed.latestRoundData() returns a value higher than the threshold    
    await smartHome.checkLightIntensity();
    expect(await lightControl.lightIntensity()).to.equal(await smartHome.thresholdLightIntensity());
  });

  // Test case: contract correctly updates alert status in SecurityAlertContract
  it("Should set alert status in SecurityAlertContract", async function () {
    // Assume that securityAlertFeed.latestRoundData() returns a value higher than the threshold    
    await smartHome.checkSecurityAlert();
    expect(await securityAlertControl.status()).to.be.true;
  });
});
