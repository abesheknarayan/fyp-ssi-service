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
        string v_key; // verification key for this particular credential definition. This is e
        string prime_n; // for modulus using RSA

        bytes32 credSchema_id; // the attributes which the credential provides based on this definition can be looked up in the corresponding schema

        bool is_revocatable; // whether the credential issued based on this credential definition could be revocated or not
    }



    mapping(address => CredentialDefinition[]) issuer_address_to_all_credential_definition; // all credential definition published by a particular trust anchor
    mapping(bytes32 => CredentialDefinition) id_to_credential_definition;   // particular credential definition
    mapping(bytes32 => bool) credential_definition_exists;   // whether a particular credential definition exists or not

    function createCredentialDefinition(string memory _name, string memory _version,
        string memory _Vkey,string memory _prime_n, bytes32 _credSchema_id, bool _isRevocatable) internal onlyStewardOrTrustAnchor returns(bytes32){

            // already existing credential definition shouldn't be modified
            bytes32 _id = keccak256(abi.encodePacked(_name,_version,tx.origin));
            require(!credential_definition_exists[_id],"Existing credential definition can't be modified");

            // checking whether the given id correspond to a credential schema
            require(credential_schema_exists[_credSchema_id],"The credential schema referred does not exist");

            CredentialDefinition memory _new_cred_definition = CredentialDefinition(_name,_id,_version,tx.origin,_Vkey,_prime_n,_credSchema_id,_isRevocatable);
            id_to_credential_definition[_id] = _new_cred_definition;
            credential_definition_exists[_id] = true;
            issuer_address_to_all_credential_definition[tx.origin].push(_new_cred_definition);

            return _id;
    }

    // if credential definition id is not known this function could be used
    function getCredentialDefinition(string memory _name, string memory _version, address _address) internal view returns(CredentialDefinition memory) {
        
        bytes32 _id = keccak256(abi.encodePacked(_name,_version,_address));
        
        // checking whether the given details correspond to a credential definition
        require(credential_definition_exists[_id],"Requested credential definition does not exist");

        return id_to_credential_definition[_id];
    }

    // if credential definition id is known then this function could be used
    function getCredentialDefinitionWithID(bytes32 _id) internal view returns(CredentialDefinition memory) {
        
        // checking whether the given id correspond to a credential definition
        require(credential_definition_exists[_id],"Requested credential definition does not exist");

        return id_to_credential_definition[_id];
    }

    function getAllCredentialDefinition(address _address) internal view returns(CredentialDefinition[] memory) {

        // checking whether the given address has atleast one credential definition
        require(issuer_address_to_all_credential_definition[_address].length >= 1,"No credential definition is published by this address");

        return issuer_address_to_all_credential_definition[_address];
    }

}
