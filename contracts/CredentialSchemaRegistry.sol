// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './Roles.sol';

// Registry for storing credential schemas
contract CredentialSchemaRegistry is Roles {

    struct CredentialSchema {
        string name;
        uint id;       // uniqueness
        address creator_address;  // modify
        string attributes; 
    }

    mapping(address => mapping(uint => CredentialSchema)) credentialSchema;

    function setCredentialSchema(string memory _name, uint _id, string memory _attributes) internal onlyStewardOrTrustAnchor {

        // already existing schema shouldn't be updated

        CredentialSchema memory new_schema = CredentialSchema(_name,_id,tx.origin,_attributes);
        credentialSchema[tx.origin][_id] = new_schema;
    }

    function getCredentialSchema(address _addr, uint _id) internal view returns(CredentialSchema memory){

        return credentialSchema[_addr][_id];
    }
}

