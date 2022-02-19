// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Roles.sol";

// Public identity records (Verinym) -> DID_Public, Vkey, URL_Public
// Same structure for private identity record (Pseudonym), but it is not stored in ledger

contract IdentityRecord is Roles {

    struct Record {
        string DID_public;
        bytes32 Vkey;
        string Url;
    }
    
    mapping(address => Record) identityRecord;
    mapping(string => bool) DID_public_exists;

    function setVerinym(address _address,string memory _DID_public, bytes32 _Vkey, string memory _Url) internal onlyStewardOrTrustAnchor {

        //checking whether the given address already have a Verinym or not
        require(entityRegistry[_address].role == Role.User,"Given address is already a trust anchor");

        // checking whether the given Public DID already exist or not
        require(!DID_public_exists[_DID_public], "This Public DID already exists");

        identityRecord[_address].DID_public = _DID_public;
        identityRecord[_address].Vkey = _Vkey;
        identityRecord[_address].Url = _Url;

        assignTrustAnchorRole(_address); // Gets the Trust anchor role as it now have a Public DID
        DID_public_exists[_DID_public] = true;

    }
              
    function getVerinym(address _address) internal view returns(Record memory) {
        return identityRecord[_address];
    }
}