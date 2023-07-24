// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract SmartHomeContract {
    
    address private owner;
    
    // Setting a threshold temperature, light intensity and security alert in percentage
    uint public thresholdTemperature = 25;
    uint public thresholdLightIntensity = 500;
    uint public thresholdSecurityAlert = 90;

    // Address of the Chainlink Oracle for temperature, light intensity and security alert respectively
    AggregatorV3Interface internal temperatureFeed;
    AggregatorV3Interface internal lightIntensityFeed;
    AggregatorV3Interface internal securityAlertFeed;

    // Events that will be emitted when threshold is crossed
    event TemperatureThresholdCrossed(uint temperature);
    event LightIntensityThresholdCrossed(uint lightIntensity);
    event SecurityAlertThresholdCrossed(uint securityAlert);

    constructor(address _temperatureFeed, address _lightIntensityFeed, address _securityAlertFeed) public {
        owner = msg.sender;
        temperatureFeed = AggregatorV3Interface(_temperatureFeed);
        lightIntensityFeed = AggregatorV3Interface(_lightIntensityFeed);
        securityAlertFeed = AggregatorV3Interface(_securityAlertFeed);
    }

    // Check the temperature, light intensity and security alert respectively
    function checkTemperature() public {
        (
            uint80 roundID, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = temperatureFeed.latestRoundData();
        
        if(uint(answer) > thresholdTemperature) {
            emit TemperatureThresholdCrossed(uint(answer));
        }
    }

    function checkLightIntensity() public {
        (
            uint80 roundID, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = lightIntensityFeed.latestRoundData();
        
        if(uint(answer) > thresholdLightIntensity) {
            emit LightIntensityThresholdCrossed(uint(answer));
        }
    }

    function checkSecurityAlert() public {
        (
            uint80 roundID, 
            int256 answer, 
            uint256 startedAt, 
            uint256 updatedAt, 
            uint80 answeredInRound
        ) = securityAlertFeed.latestRoundData();
        
        if(uint(answer) > thresholdSecurityAlert) {
            emit SecurityAlertThresholdCrossed(uint(answer));
        }
    }
}
