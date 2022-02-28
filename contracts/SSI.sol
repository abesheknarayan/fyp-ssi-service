// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './EntityRegistry.sol';
import './RevocationRegistry.sol';

contract SSI is EntityRegistry,RevocationRegistryList {
    address owner;

    constructor() {
        owner = msg.sender;
        Entity memory owner_entity;
        owner_entity.role = Role.Steward;
        address_to_entity[owner] = owner_entity;
    }

    // different name cuz solidity doesnt allow function overriding with different visibility
    function createCredentialSchemaSSI(string memory _name, string memory _version, string memory _attributes) public {
        createCredentialSchema(_name, _version, _attributes);
    }

    function getAllOwnedCredentialSchemas() view public returns(CredentialSchema[] memory){
        return getAllCredentialSchemas(tx.origin);
    }

    function createCredentialDefinitionSSI(string memory _name, string memory _version,
        bytes32 _Vkey, bytes32 _credSchema_id, bool _isRevocatable) public {
            createCredentialDefinition(_name, _version, _Vkey, _credSchema_id, _isRevocatable);
        }
    
    function getAllOwnedCredentialDefiniton() view public returns 
    (CredentialDefinition[] memory) {
        return getAllCredentialDefinition(tx.origin);
    }
}
