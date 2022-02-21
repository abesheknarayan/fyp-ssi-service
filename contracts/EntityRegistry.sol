// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


// contains the contract related to Entity and its functionality and a entity registry for verinyms
contract EntityRegistry {

    enum Role {
        Steward,
        TrustAnchor,
        User
    }


    struct Entity {
        Role role;
    }

    mapping(address => Entity) address_to_entity;

}
