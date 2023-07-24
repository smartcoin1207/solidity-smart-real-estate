// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;


import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


// ============================================================================
// Contracts
// ============================================================================

contract TemperatureControlContract {
    function setTemperature(uint temperature) public { /* ... */ }
}

contract LightControlContract {
    function setLightIntensity(uint lightIntensity) public { /* ... */ }
}

contract SecurityAlertContract {
    function setAlertStatus(bool status) public { /* ... */ }
}

contract SmartHomeContract {

    // Parameters
    // ========================================================================

    address private owner;
    
    uint public thresholdTemperature = 25;
    uint public thresholdLightIntensity = 500;
    uint public thresholdSecurityAlert = 90;


    // Constructor
    // ========================================================================

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


    // Aggregators
    // ========================================================================

    AggregatorV3Interface internal temperatureFeed;
    AggregatorV3Interface internal lightIntensityFeed;
    AggregatorV3Interface internal securityAlertFeed;


    // Contracts
    // ========================================================================

    // Adding the contracts for temperature, light and security control
    TemperatureControlContract public temperatureControl;
    LightControlContract public lightControl;
    SecurityAlertContract public securityAlertControl;


    // Events
    // ========================================================================

    event TemperatureThresholdCrossed(uint temperature);
    event LightIntensityThresholdCrossed(uint lightIntensity);
    event SecurityAlertThresholdCrossed(uint securityAlert);


    // Methods
    // ========================================================================

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
            lightControl.setLightIntensity(thresholdLightIntensity); // reduce light intensity
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
        
        uint securityAlert = uint(answer);
        if(securityAlert > thresholdSecurityAlert) {
            emit SecurityAlertThresholdCrossed(securityAlert);
            securityAlertControl.setAlertStatus(true); // trigger alert
        }
    }

}
