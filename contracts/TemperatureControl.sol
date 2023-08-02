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


// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


// ============================================================================
// Contracts
// ============================================================================

/**
 *  @title Temperature Control Contract
 *  @author Lars Bastiaan van Vianen
 *  @notice This contract allows setting the temperature value for a simulated smart home system.
 *  @dev Alpha version
 *  @custom:experimental This is an experimental contract.
 */
contract TemperatureControlContract {

    /**
     *  @notice Represents the current temperature of the smart home system
     */
    uint public temperature;
    
    /**
     *  @notice Sets the temperature of the smart home system
     *  @param _temperature The temperature to set
     */
    function setTemperature(uint _temperature) public {
        temperature = _temperature;
    }
}
