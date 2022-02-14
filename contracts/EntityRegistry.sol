// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './Entity.sol';

// contains the contract related to Entity and its functionality and a entity registry for verinyms
contract EntityRegistry is Entity {
    mapping(address => Entity) entityRegistry;
}
