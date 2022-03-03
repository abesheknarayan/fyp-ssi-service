// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./EntityRegistry.sol";
import "./RevocationRegistry.sol";

contract SSI is EntityRegistry, RevocationRegistryList {
    address owner;

    constructor() {
        owner = msg.sender;
        Entity memory owner_entity;
        owner_entity.role = Role.Steward;
        address_to_entity[owner] = owner_entity;
    }

    event SendCredentialDefinitionId(bytes32 _credential_definition_id);

    // different name cuz solidity doesnt allow function overriding with different visibility
    function createCredentialSchemaSSI(
        string memory _name,
        string memory _version,
        string memory _attributes
    ) public {
        createCredentialSchema(_name, _version, _attributes);
    }

    function getAllOwnedCredentialSchemas()
        public
        view
        returns (CredentialSchema[] memory)
    {
        return getAllCredentialSchemas(tx.origin);
    }

    function createCredentialDefinitionSSI(
        string memory _name,
        string memory _version,
        string memory _Vkey,
        string memory _prime_n,
        bytes32 _credSchema_id,
        bool _isRevocatable
    ) public {
       bytes32 _credential_definition_id = createCredentialDefinition(_name, _version, _Vkey,_prime_n, _credSchema_id, _isRevocatable);
        // TODO: Create revocation registry

        emit SendCredentialDefinitionId(_credential_definition_id);
    }

    function getAllOwnedCredentialDefinitions()
        public
        view
        returns (CredentialDefinition[] memory)
    {
        return getAllCredentialDefinition(tx.origin);
    }
}
