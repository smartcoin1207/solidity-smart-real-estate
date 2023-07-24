<div align="right">

  [![license](https://img.shields.io/github/license/block-foundation/solidity-smart-home?color=green&label=license&style=flat-square)](LICENSE.md)
  ![stars](https://img.shields.io/github/stars/block-foundation/solidity-smart-home?color=blue&label=stars&style=flat-square)
  ![contributors](https://img.shields.io/github/contributors/block-foundation/solidity-smart-home?color=blue&label=contributors&style=flat-square)

</div>

---

<div>
    <img align="right" src="https://raw.githubusercontent.com/block-foundation/brand/master/logo/logo_gray.png" width="96" alt="Block Foundation Logo">
    <h1 align="left">Blockchain Enabled Smart Home</h1>
    <h3 align="left">Block Foundation Smart Contract Series [Solidity]</h3>
</div>

---

<div>
<img align="right" width="75%" src="https://raw.githubusercontent.com/block-foundation/brand/master/image/repository_cover/block_foundation-structure-03-accent.jpg"  alt="Block Foundation">
<br>
<details open="open">
<summary>Table of Contents</summary>
  
- [Introduction](#style-guide)
- [Quick Start](#quick-start)
- [Contract](#contract)
- [Development Resources](#development-resources)
- [Legal Information](#legal-information)
  - [Copyright](#copyright)
  - [License](#license)
  - [Warning](#warning)
  - [Disclaimer](#disclaimer)

</details>
</div>

<br clear="both"/>

## Introduction

Welcome to the Blockchain Enabled Smart Home project, where we leverage the power of blockchain technology to bring automation, security, and efficiency to your home environment.

In the era of the Internet of Things (IoT), where all devices are becoming smarter and interconnected, our homes are not left behind. The concept of smart homes has rapidly emerged, providing people with increased comfort, energy efficiency, and home security. However, the integration of blockchain in this domain is still relatively new and opens up a myriad of opportunities.

Our project aims to harness the benefits of blockchain, specifically Ethereum and Algorand platforms, to enhance the functionality and efficiency of a smart home. We employ smart contracts to automate home functions such as temperature control, light intensity regulation, and security alert systems based on external data inputs. These data inputs are provided by oracle services, which fetch real-world data and bring them onto the blockchain.

In our Ethereum-based implementation, we utilize the Solidity programming language to write smart contracts that interact with Chainlink oracles for fetching external data. These smart contracts are designed to react when certain thresholds, such as temperature or light intensity, are crossed, triggering corresponding actions like adjusting the temperature or light intensity, or sending a security alert.

In the Algorand version, we use PyTeal, a Python language binding for Algorand's smart contract language, TEAL. Due to Algorand's UTXO-based model and the stateful nature of its smart contracts, we construct a simplified version of a state machine to track variables such as temperature.

Although the idea of integrating blockchain technology into smart homes may seem complex, it brings forth numerous advantages, such as enhanced security, transparency, and automation. Through our project, we aim to provide a robust, decentralized, and secure smart home system that paves the way for the future of home automation.

We look forward to taking you on this innovative journey of transforming homes into blockchain-enabled smart homes.

## Quick Start

> Install

``` sh
npm i
```

> Compile

``` sh
npm run compile
```

## Contract

In a smart home scenario, we could imagine a smart contract that regulates and automates various functions like temperature control, light control, security etc. based on external data feeds provided by oracles. This is an oversimplified version to demonstrate the concept. In the real-world, access controls would be required for these functions to prevent anyone other than the contract owner or authorized parties from invoking these actions. Additionally, these external contract calls could fail and the smart contract should handle these failures gracefully. The oracles also need to be trusted and secure.

This example utilizes **Chainlink's Oracle** solution to retrieve external data. The three functions `checkTemperature`, `checkLightIntensity` and `checkSecurityAlert` fetches the latest data from each respective oracle feed and checks if it crosses a certain threshold. If it does, it emits an event, which can be listened to and acted upon.

For real world usage, you may want the smart contract to also have the ability to act on this information, such as by interacting with other smart contracts to automatically adjust the temperature, light intensity or alert the security company in case of a security alert.

We use three external contracts as examples: `TemperatureControlContract`, `LightControlContract` and `SecurityAlertContract`. These contracts should include the `setTemperature`, `setLightIntensity` and `setAlertStatus` methods respectively, that we could call to change the house's state.

*Note: Due to the complexity and security considerations in smart contract development, especially when oracles or any form of external data is involved, this contract should not be used as is. It's a rudimentary demonstration and actual deployment would require additional features like error handling, security precautions (like checking the source of the oracle data), efficiency optimizations, etc.*

## Development Resources

### Other Repositories

#### Block Foundation Smart Contract Series

|                                   | `Solidity`  | `Teal`      |
| --------------------------------- | ----------- | ----------- |
| **Template**                      | [**>>>**](https://github.com/block-foundation/solidity-template) | [**>>>**](https://github.com/block-foundation/teal-template) |
| **Architectural Design**          | [**>>>**](https://github.com/block-foundation/solidity-architectural-design) | [**>>>**](https://github.com/block-foundation/teal-architectural-design) |
| **Architecture Competition**      | [**>>>**](https://github.com/block-foundation/solidity-architecture-competition) | [**>>>**](https://github.com/block-foundation/teal-architecture-competition) |
| **Housing Cooporative**           | [**>>>**](https://github.com/block-foundation/solidity-housing-cooperative) | [**>>>**](https://github.com/block-foundation/teal-housing-cooperative) |
| **Land Registry**                 | [**>>>**](https://github.com/block-foundation/solidity-land-registry) | [**>>>**](https://github.com/block-foundation/teal-land-registry) |
| **Real-Estate Crowdfunding**      | [**>>>**](https://github.com/block-foundation/solidity-real-estate-crowdfunding) | [**>>>**](https://github.com/block-foundation/teal-real-estate-crowdfunding) |
| **Rent-to-Own**                   | [**>>>**](https://github.com/block-foundation/solidity-rent-to-own) | [**>>>**](https://github.com/block-foundation/teal-rent-to-own) |
| **Self-Owning Building**          | [**>>>**](https://github.com/block-foundation/solidity-self-owning-building) | [**>>>**](https://github.com/block-foundation/teal-self-owning-building) |
| **Smart Home**                    | [**>>>**](https://github.com/block-foundation/solidity-smart-home) | [**>>>**](https://github.com/block-foundation/teal-smart-home) |

## Legal Information

### Copyright

Copyright 2023, [Stichting Block Foundation](https://www.blockfoundation.io). All rights reserved.

### License

Except as otherwise noted, the content in this repository is licensed under the
[Creative Commons Attribution 4.0 International (CC BY 4.0) License](https://creativecommons.org/licenses/by/4.0/), and
code samples are licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).

Also see [LICENSE](https://github.com/block-foundation/community/blob/master/LICENSE) and [LICENSE-CODE](https://github.com/block-foundation/community/blob/master/LICENSE-CODE).

### Warning

**Please note that this code should be audited by a professional smart-contract auditor before being used in a production environment as it is a simplified example and may not cover all potential security vulnerabilities.**

### Disclaimer

**THIS SOFTWARE IS PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.**
