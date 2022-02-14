// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Types.sol";
import "./EntityRegistry.sol";

contract Roles is Types, EntityRegistry {
    modifier onlyStewardOrTrustAnchor() {
        Entity caller = address_to_entity(req.sender);
        require(caller.role == Role.Steward || caller.role == Role.TrustAnchor);
        _;
    }

    modifier onlySteward() {
        Entity caller = address_to_entity(req.sender);
        require(caller.role == Role.Steward);
        _;
    }

    function assignTrustAnchorRole(address _address) stewardOrTrustAnchor {
        // can only change role from User to Trust Anchor
        require(address_to_entity(_address).role == User);
        address_to_entity(_address).role = Role.TrustAnchor;
    }

    // additional feature to revocate trust anchor role. Can only be done by steward (Remove if unnecessary)
    function RevocateTrustAnchorRole(address _address) onlySteward {
        // can only change role from Trust Anchor to User
        require(address_to_entity(_address).role == TrustAnchor);
        address_to_entity(_address).role = Role.User;
    }
}
