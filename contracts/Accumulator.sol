// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Roles.sol";
import "./CredentialSchemaRegistry.sol";

/*
Since crypto functions arent compatible yet with solidity , all crypto calculations can be done offline (using another python / nodejs server) and just the calculated value is sent to the smart contracts where it will be stored
*/

contract Accumulator is Roles, CredentialSchemaRegistry {
    int256 prime;
    int256 accumulator_value;
    bytes32 credentialSchemaHash;

    // key is the hash of issued credential mapped to its witness
    mapping(bytes32 => int256) credentialHash_to_witness;

    // only credential owner can call functions related to that credential
    modifier isCredentialOwner() {
        require(
            credential_schema_hash_to_issuer_entity_address_hash[credentialSchemaHash] ==  keccak256(abi.encodePacked(msg.sender))
        );
        _;
    }

    // adds a new cred hash to accumulator
    function setAccumulator(int256 _accumulator_value)
        internal
        onlyStewardOrTrustAnchor
    {
        accumulator_value = _accumulator_value;
    }

    function getAccumulator() internal view returns (int256) {
        return accumulator_value;
    }

    // credentialHash is the hash of credential issued not the schema
    function getWitness(string memory _credentialHash)
        internal
        view
        returns (int256)
    {
        return credentialHash_to_witness[keccak256(abi.encodePacked(_credentialHash))];
    }
}
