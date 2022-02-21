// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './EntityRegistry.sol';
import './RevocationRegistry.sol';

contract SSI is EntityRegistry,RevocationRegistryList {
    address owner;

    constructor() {
        owner = msg.sender;
        Entity memory ownerEntity;
        ownerEntity.role = Role.Steward;
        entityRegistry[owner] = ownerEntity;
    }
}
