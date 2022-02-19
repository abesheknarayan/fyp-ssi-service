// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './Roles.sol';

// Registry for storing credential schemas
contract CredentialSchemaRegistry is Roles {

    struct CredentialSchema {
        string name;
        bytes32 id;
        string version;
        address creator_address;
        string attributes; 
    }

    mapping(address => CredentialSchema[]) allCredentialSchema;   // all credential schemas published by a particular trust anchor
    mapping(bytes32 => CredentialSchema) credentialSchema;   // particular credential schema
    mapping(bytes32 => bool) credential_schema_exists;   // whether a particular credential schema exists or not

    function setCredentialSchema(string memory _name, string memory _version, string memory _attributes) internal onlyStewardOrTrustAnchor {

        // already existing schema shouldn't be modified
        bytes32 _id = keccak256(abi.encodePacked(_name,_version,tx.origin));
        require(!credential_schema_exists[_id],"Existing Schema can't be modified");

        CredentialSchema memory new_schema = CredentialSchema(_name,_id,_version,tx.origin,_attributes);
        credentialSchema[_id] = new_schema;
        credential_schema_exists[_id] = true;
        allCredentialSchema[tx.origin].push(new_schema);
    }

    // if credential schema id is not known this function could be used
    function getCredentialSchema(string memory _name, string memory _version, address _address) internal view returns(CredentialSchema memory){

        bytes32 _id = keccak256(abi.encodePacked(_name,_version,_address));

        // checking whether the given details correspond to a credential schema
        require(credential_schema_exists[_id],"Requested credential schema does not exist");

        return credentialSchema[_id];
    }

    // if credential schema id is known then this function could be used
    function getCredentialSchemaWithID(bytes32 _id) internal view returns(CredentialSchema memory){

        // checking whether the given id correspond to a credential schema
        require(credential_schema_exists[_id],"Requested credential schema does not exist");

        return credentialSchema[_id];
    }

    // retriving all the credential schemas published by a particular turst anchor.
    function getAllCredentialSchemas(address _address) internal view returns(CredentialSchema[] memory) {

        // checking whether the given address has atleast one credential schema
        require(allCredentialSchema[_address].length >= 1,"No credential schema is published by this address");

        return allCredentialSchema[_address];
    }
}