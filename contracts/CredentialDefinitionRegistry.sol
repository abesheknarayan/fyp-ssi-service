// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './Roles.sol';
import './CredentialSchemaRegistry.sol';

// Registry for storing credential definition
contract CredentialDefinitionRegistry is Roles, CredentialSchemaRegistry {

    struct CredentialDefinition {
        string name;
        bytes32 id;
        string version;
        address issuer_address;
        bytes32 Vkey; // verification key for this particular credential definition.

        bytes32 credSchema_id; // the attributes which the credential provides based on this definition can be looked up in the corresponding schema

        bool isRevocatable; // whether the credential issued based on this credential definition could be revocated or not
    }



    mapping(address => CredentialDefinition[]) allCredentialDefinition; // all credential definition published by a particular trust anchor
    mapping(bytes32 => CredentialDefinition) credentialDefinition;   // particular credential definition
    mapping(bytes32 => bool) credential_definition_exists;   // whether a particular credential definition exists or not

    function createCredentialDefinition(string memory _name, string memory _version,
        bytes32 _Vkey, bytes32 _credSchema_id, bool _isRevocatable) internal onlyStewardOrTrustAnchor{

            // already existing credential definition shouldn't be modified
            bytes32 _id = keccak256(abi.encodePacked(_name,_version,tx.origin));
            require(!credential_definition_exists[_id],"Existing credential definition can't be modified");

            // checking whether the given id correspond to a credential schema
            require(credential_schema_exists[_credSchema_id],"The credential schema referred does not exist");

            CredentialDefinition memory new_cred_definition = CredentialDefinition(_name,_id,_version,tx.origin,_Vkey,_credSchema_id,_isRevocatable);
            credentialDefinition[_id] = new_cred_definition;
            credential_definition_exists[_id] = true;
            allCredentialDefinition[tx.origin].push(new_cred_definition);

    }

    // if credential definition id is not known this function could be used
    function getCredentialDefinition(string memory _name, string memory _version, address _address) internal view returns(CredentialDefinition memory) {
        
        bytes32 _id = keccak256(abi.encodePacked(_name,_version,_address));
        
        // checking whether the given details correspond to a credential definition
        require(credential_definition_exists[_id],"Requested credential definition does not exist");

        return credentialDefinition[_id];
    }

    // if credential definition id is known then this function could be used
    function getCredentialDefinitionWithID(bytes32 _id) internal view returns(CredentialDefinition memory) {
        
        // checking whether the given id correspond to a credential definition
        require(credential_definition_exists[_id],"Requested credential definition does not exist");

        return credentialDefinition[_id];
    }

    function getAllCredentialDefinition(address _address) internal view returns(CredentialDefinition[] memory) {

        // checking whether the given address has atleast one credential definition
        require(allCredentialDefinition[_address].length >= 1,"No credential definition is published by this address");

        return allCredentialDefinition[_address];
    }

}
