// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './EntityRegistry.sol';

// Registry for storing credential schemas
contract CredentialSchemaRegistry is EntityRegistry {

    struct CredentialSchema {
        Entity owner;
    }


}
