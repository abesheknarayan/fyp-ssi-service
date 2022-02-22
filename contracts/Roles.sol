// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./EntityRegistry.sol";

contract Roles is EntityRegistry {
    modifier onlyStewardOrTrustAnchor() {
        Role callerRole = address_to_entity[tx.origin].role;
        require(callerRole == Role.Steward || callerRole == Role.TrustAnchor,"This function is restricted to steward or trust anchor");
        _;
    }

    modifier onlySteward() {
        Role callerRole = address_to_entity[tx.origin].role; 
        require(callerRole == Role.Steward,"This function is restricted to steward");
        _;
    }

    function assignTrustAnchorRole(address _address)
        internal
        onlyStewardOrTrustAnchor
    {
        // can only change role from User to Trust Anchor
        require(address_to_entity[_address].role == Role.User,"Given address is not a User role");
        address_to_entity[_address].role = Role.TrustAnchor;
    }

}
