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

    event SendCredentialSchemaId(bytes32 _credential_schema_id);

    // different name cuz solidity doesnt allow function overriding with different visibility
    function createCredentialSchemaSSI(
        string memory _name,
        string memory _version,
        string memory _attributes
    ) public {
       bytes32 _credential_schema_id = createCredentialSchema(_name, _version, _attributes);
       emit SendCredentialSchemaId(_credential_schema_id);
    }

    function getCredentialSchemaWithIDSSI(
        bytes32 _credential_schema_id
    ) public view returns (CredentialSchema memory) {
        return getCredentialSchemaWithID(_credential_schema_id);
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
        VerificationKey memory _V_Key,
        bytes32 _credSchema_id,
        bool _isRevocatable
    ) public {
       bytes32 _credential_definition_id = createCredentialDefinition(_name, _version,_V_Key, _credSchema_id, _isRevocatable);
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

    function getCredentialDefinitionWithIDSSI(
        bytes32 _definition_id
    ) public view returns (CredentialDefinition memory) {
        return getCredentialDefinitionWithID(_definition_id);
    }
}
