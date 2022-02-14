// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./EntityRegistry.sol";

contract Roles is EntityRegistry {
    modifier onlyStewardOrTrustAnchor() {
        Role callerRole = entityRegistry[msg.sender].role;
        require(callerRole == Role.Steward || callerRole == Role.TrustAnchor);
        _;
    }

    modifier onlySteward() {
        Role callerRole = entityRegistry[msg.sender].role; 
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

    // additional feature to revocate trust anchor role. Can only be done by steward (Remove if unnecessary)
    function RevocateTrustAnchorRole(address _address) internal onlySteward {
        // can only change role from Trust Anchor to User
        require(entityRegistry[_address].role == Role.TrustAnchor);
        entityRegistry[_address].role = Role.User;
    }
}
