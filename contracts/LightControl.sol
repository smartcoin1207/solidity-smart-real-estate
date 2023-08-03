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


pragma solidity ^0.8.17; 


// ============================================================================
// Import
// ============================================================================

// Remote
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol'; 
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol'; 
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


// ============================================================================
// Contracts
// ============================================================================

/**
 *  @title LightControlContract
 *  @author Lars Bastiaan van Vianen
 *  @notice This contract allows setting the light intensity value for a
 *  simulated smart home system.
 */
contract LightControlContract {

    /**
     *  @notice Represents the current light intensity of the smart home system
     */
    uint public lightIntensity;
    
    /**
     *  @notice Sets the light intensity of the smart home system
     *  @param _lightIntensity The light intensity to set
     */
    function setLightIntensity(uint _lightIntensity) public {
        lightIntensity = _lightIntensity;
    }
}