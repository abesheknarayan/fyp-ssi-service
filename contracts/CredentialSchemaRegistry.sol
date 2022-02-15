// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './EntityRegistry.sol';

// Registry for storing credential schemas
contract CredentialSchemaRegistry is EntityRegistry {

    struct CredentialSchema {
        Entity owner;
    }

    // mapping of credential schema hash to hash of address of issuer (required in accumulator modifier checking)
    mapping(bytes32  => bytes32) credential_schema_hash_to_issuer_entity_address_hash;

}
