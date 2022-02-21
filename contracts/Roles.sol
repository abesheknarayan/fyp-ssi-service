// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./EntityRegistry.sol";

contract Roles is EntityRegistry {
    modifier onlyStewardOrTrustAnchor() {
        Role callerRole = address_to_entity[tx.origin].role;
        require(callerRole == Role.Steward || callerRole == Role.TrustAnchor);
        _;
    }

    modifier onlySteward() {
        Role callerRole = address_to_entity[tx.origin].role; 
        require(callerRole == Role.Steward);
        _;
    }

    function assignTrustAnchorRole(address _address)
        internal
        onlyStewardOrTrustAnchor
    {
        // can only change role from User to Trust Anchor
        require(address_to_entity[_address].role == Role.User);
        address_to_entity[_address].role = Role.TrustAnchor;
    }

}
