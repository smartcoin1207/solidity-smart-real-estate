// SPDX-License-Identifier: Apache-2.0


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


pragma solidity ^0.8.19;


// ============================================================================
// Contracts
// ============================================================================

// Remote
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

// Local
import "./LightControl.sol";
import "./TemperatureControl.sol";
import "./SecurityAlert.sol";


// ============================================================================
// Contracts
// ============================================================================

/**
 *  @title SmartHomeContract
 *  @author Lars Bastiaan van Vianen
 *  @notice This contract allows management of various parameters of a
 *  simulated smart home system.
 *  @dev It uses the Chainlink Aggregator V3 Interface to fetch temperature,
 *  light intensity, and security alert data.
*/
contract SmartHomeContract {

    // Parameters
    // ========================================================================

    /**
     *  @notice The owner of the contract (generally the deployer)
     */
    address private owner;

    /**
     *  @notice Threshold for the temperature in the smart home system.
     *  Default is 25.
     */
    uint public thresholdTemperature = 25;

    /**
     *  @notice Threshold for the light intensity in the smart home system.
     *  Default is 500.
     */
    uint public thresholdLightIntensity = 500;

    /**
     *  @notice Threshold for the security alert in the smart home system.
     *  Default is 90.
     */
    uint public thresholdSecurityAlert = 90;


    // Aggregators
    // ------------------------------------------------------------------------

    /**
     *  @notice Interface to the temperature data feed
     */
    AggregatorV3Interface internal temperatureFeed;

    /**
     *  @notice Interface to the light intensity data feed
     */
    AggregatorV3Interface internal lightIntensityFeed;

    /**
     *  @notice Interface to the security alert data feed
     */
    AggregatorV3Interface internal securityAlertFeed;


    // Contract References
    // ------------------------------------------------------------------------

    /**
     *  @notice Reference to the contract that controls temperature of the
     *  smart home system
     */
    TemperatureControlContract public temperatureControl;

    /**
     *  @notice Reference to the contract that controls light intensity of the
     *  smart home system
     */
    LightControlContract public lightControl;

    /**
     *  @notice Reference to the contract that controls security alert status
     *  of the smart home system
     */
    SecurityAlertContract public securityAlertControl;


    // Constructor
    // ========================================================================

    /**
     *  @notice Creates a new SmartHomeContract instance
     *  @dev The contract uses the provided oracle feeds and control contract 
     *  addresses
     *  @param _temperatureFeed The address of the temperature data oracle
     *  @param _lightIntensityFeed The address of the light intensity data oracle
     *  @param _securityAlertFeed The address of the security alert data oracle
     *  @param _temperatureControl The address of the TemperatureControlContract
     *  @param _lightControl The address of the LightControlContract
     *  @param _securityAlertControl The address of the SecurityAlertContract
     */
    constructor(
        address _temperatureFeed,
        address _lightIntensityFeed,
        address _securityAlertFeed,
        TemperatureControlContract _temperatureControl,
        LightControlContract _lightControl,
        SecurityAlertContract _securityAlertControl
    ) public {
        owner = msg.sender;
        temperatureFeed = AggregatorV3Interface(_temperatureFeed);
        lightIntensityFeed = AggregatorV3Interface(_lightIntensityFeed);
        securityAlertFeed = AggregatorV3Interface(_securityAlertFeed);
        temperatureControl = _temperatureControl;
        lightControl = _lightControl;
        securityAlertControl = _securityAlertControl;
    }


    // Events
    // ========================================================================

    /**
     *  @notice Emitted when the current temperature crosses the defined threshold
     *  @param temperature The current temperature
     */
    event TemperatureThresholdCrossed(uint temperature);

    /**
     *  @notice Emitted when the current light intensity crosses the defined threshold
     *  @param lightIntensity The current light intensity
     */
    event LightIntensityThresholdCrossed(uint lightIntensity);

    /**
     *  @notice Emitted when the current security alert level crosses the defined threshold
     *  @param securityAlert The current security alert level
     */
    event SecurityAlertThresholdCrossed(uint securityAlert);


    // Modifiers
    // ========================================================================

    /**
     *  @dev Ensures the caller is the owner
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    // Methods
    // ========================================================================


    // Setters
    // ------------------------------------------------------------------------

    /**
     *  @notice Sets the threshold temperature for the smart home system
     *  @dev Can only be called by the contract owner
     *  @param _thresholdTemperature The new threshold temperature
     */
    function setThresholdTemperature(
        uint _thresholdTemperature
    ) public onlyOwner {
        thresholdTemperature = _thresholdTemperature;
    }

    /**
     *  @notice Sets the threshold light intensity for the smart home system
     *  @dev Can only be called by the contract owner
     *  @param _thresholdLightIntensity The new threshold light intensity
     */
    function setThresholdLightIntensity(
        uint _thresholdLightIntensity
    ) public onlyOwner {
        thresholdLightIntensity = _thresholdLightIntensity;
    }

    /**
     *  @notice Sets the threshold security alert level for the smart home system
     *  @dev Can only be called by the contract owner
     *  @param _thresholdSecurityAlert The new threshold security alert level
     */
    function setThresholdSecurityAlert(
        uint _thresholdSecurityAlert
    ) public onlyOwner {
        thresholdSecurityAlert = _thresholdSecurityAlert;
    }

    // Checkers
    // ------------------------------------------------------------------------

    /**
     *  @notice Checks the current temperature from the data feed and adjusts the system temperature if needed
     *  @dev This emits a TemperatureThresholdCrossed event if the temperature exceeds the threshold
     */
    function checkTemperature() public {
        (
            uint80 roundID, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = temperatureFeed.latestRoundData();
        
        uint temperature = uint(answer);
        if(temperature > thresholdTemperature) {
            emit TemperatureThresholdCrossed(temperature);
            temperatureControl.setTemperature(thresholdTemperature); // reduce temperature
        }
    }

    /**
     *  @notice Checks the current light intensity from the data feed and 
     *  adjusts the system light intensity if needed
     *  @dev This emits a LightIntensityThresholdCrossed event if the light
     *  intensity exceeds the threshold
     */
    function checkLightIntensity() public {
        (
            uint80 roundID, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = lightIntensityFeed.latestRoundData();
        
        uint lightIntensity = uint(answer);

        if(lightIntensity > thresholdLightIntensity) {
            emit LightIntensityThresholdCrossed(lightIntensity);

            // reduce light intensity
            lightControl.setLightIntensity(thresholdLightIntensity);
        }
    }

    /**
     *  @notice Checks the current security alert status from the data feed and
     *  adjusts the system security alert status if needed
     *  @dev This emits a SecurityAlertThresholdCrossed event if the security
     *  alert status exceeds the threshold
     */
    function checkSecurityAlert() public {
        (
            uint80 roundID, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = securityAlertFeed.latestRoundData();
        
        uint securityAlert = uint(answer);

        if(securityAlert > thresholdSecurityAlert) {
            emit SecurityAlertThresholdCrossed(securityAlert);

            // trigger alert
            securityAlertControl.setAlertStatus(true);
        }
    }

}
