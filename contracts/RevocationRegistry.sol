// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Accumulator.sol";

contract RevocationRegistry is Accumulator {
    // mapping of hash of credential definition to its accumulators
    mapping(string  => Accumulator) revocationRegistry;
}
