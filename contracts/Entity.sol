// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Entity {
    enum Role {
        Steward,
        TrustAnchor,
        User
    }

    Role role;
    // add others according to verinym in EntityRegistry
}
