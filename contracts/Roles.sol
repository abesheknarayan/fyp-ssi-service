// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./EntityRegistry.sol";

contract Roles is EntityRegistry {
    modifier onlyStewardOrTrustAnchor() {
        Role callerRole = entityRegistry[tx.origin].role;
        require(callerRole == Role.Steward || callerRole == Role.TrustAnchor);
        _;
    }

    modifier onlySteward() {
        Role callerRole = entityRegistry[tx.origin].role; 
        require(callerRole == Role.Steward);
        _;
    }

    function assignTrustAnchorRole(address _address)
        internal
        onlyStewardOrTrustAnchor
    {
        // can only change role from User to Trust Anchor
        require(entityRegistry[_address].role == Role.User);
        entityRegistry[_address].role = Role.TrustAnchor;
    }

}
