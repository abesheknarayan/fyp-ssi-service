// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './EntityRegistry.sol';
import './RevocationRegistry.sol';

contract SSI is EntityRegistry,RevocationRegistry {
    address owner;

    constructor() {
        owner = msg.sender;
        Entity ownerEntity;
        ownerEntity.role = Role.Steward;
        EntityRegistry[owner] = ownerEntity;
    }



}