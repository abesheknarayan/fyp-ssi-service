// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Roles.sol";

// Public identity records (Verinym) -> DID_Public, Vkey, URL_Public
// Same structure for private identity record (Pseudonym), but it is not stored in ledger

contract IdentityRecord is Roles {

    struct Record {
        int256 DID_public;
        bytes32 Vkey;
        string Url;
    }
    
    mapping(address => Record) identityRecord;

    function Verinym(address _address,int256 _DID_public, bytes32 _Vkey, string memory _Url) internal onlyStewardOrTrustAnchor {

        identityRecord[_address].DID_public = _DID_public;
        identityRecord[_address].Vkey = _Vkey;
        identityRecord[_address].Url = _Url;

        assignTrustAnchorRole(_address); // Gets the Trust anchor role as it now have a Public DID

    }
              

}