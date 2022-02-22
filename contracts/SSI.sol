// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './EntityRegistry.sol';
import './RevocationRegistry.sol';

contract SSI is EntityRegistry,RevocationRegistryList {
    address owner;

    constructor() {
        owner = msg.sender;
        Entity memory owner_entity;
        owner_entity.role = Role.Steward;
        address_to_entity[owner] = owner_entity;
    }
}
