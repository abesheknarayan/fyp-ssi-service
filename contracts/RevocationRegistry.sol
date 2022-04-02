// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./CredentialDefinitionRegistry.sol";

/*

Since crypto functions arent compatible yet with solidity , all crypto calculations can be done offline (using another python / nodejs server) and just the calculated value is sent to the smart contracts where it will be stored

Witnesses can be public (in blockchain) but not the hash of any issued credential

Issuer keeps the hash of issued credential with himself and use it for revocation (implementation is not related to blockchain and in our case it can be done as a part of wallet using db)

Accumulator logic: 

Basically given H(c) where H is some function (maybe hash or one-way prime mapping) and c is the credential's revocation id (private)
Compute witness =  g^H(c) over a field G where g is the generator.

let S be the set of H(c)'s and P be the product of all elements in S
Accumulator value = P (Public also secure as only issuer and I knows its factor(s))
Public Witness for a value X => g^(P/X) where X is a member
Private Witness for a value X => P/X (only issuer / I can compute)

All witnesses are public

Issuer's wallet:

Issuer should keep all the credentials in his private db or atleast its revocation ids and its witness mappings
Whenever he wants to revocate a credential, following steps are involved
1. Except the revocated Id's witness , change all other witness values and publish new witness list
2. Publish new accumulator value

Similarly for issuing a credential

While issuing credential, an public witness index will be given along with revocation id which user will use to get the updated public witness during verification

Possible non-revocation proof using sigma protocol:

Indentity Holder - I
Verifier - V

I gives a commitment for a public witness W as well as W.
V can check if witness is present in the blockchain.
Then I will give zkp for his credential revocation using given commitment of witness.

A decent zkp flow: (needs to be checked !!!)
public Witness WC = g^(k)^r1, while doing this using the index in credential I will get the recent revocated value
prover chooses a random number r2 to computes (xr2) where x is the H(revocation id)
prover gives WC,xr2,r1r2. Hard to compute k and x from kr1,xr2 (Factorization problem RSA)
then verifier will check if accumulator^(r1*r2) = WC^(xr2)
*/



contract RevocationRegistryList is CredentialDefinitionRegistry {

    struct Accumulator {
        uint64  prime_number; // storing it as string to prevent overflows
        uint64 generator;
        uint64  accumulator_value;
    }

    struct RevocationRegistry {
        bytes32 credential_definition_id;
        uint64[] public_witness_list;
        Accumulator accumulator;
    }
    // mapping from credential definition id to revocation registry
    mapping(bytes32 => RevocationRegistry) credential_definition_id_to_revocation_registry; 


    modifier isCredentialDefinitionIssuer(bytes32 _credential_definition_id) {
        require(id_to_credential_definition[_credential_definition_id].issuer_address == tx.origin,"Credential definition doesnt belong to this address");
        _;
    }


    function createRevocationRegistry(bytes32 _credential_definition_id,uint64[] memory _public_witness_list,uint64 _prime_number,uint64  _generator,uint64  _accumulator_value) internal isCredentialDefinitionIssuer(_credential_definition_id) {
        Accumulator memory _accumulator = Accumulator(_prime_number,_generator,_accumulator_value);
        RevocationRegistry memory _revocationRegistry = RevocationRegistry(_credential_definition_id,_public_witness_list,_accumulator);
        credential_definition_id_to_revocation_registry[_credential_definition_id] = _revocationRegistry;
    }

    function getAccumulator(bytes32 _credential_definition_id) internal view returns (Accumulator memory) {
        return credential_definition_id_to_revocation_registry[_credential_definition_id].accumulator;
    }

    function setAccumulator(bytes32 _credential_definition_id,uint64 _accumulator_value) internal isCredentialDefinitionIssuer(_credential_definition_id)  {
        credential_definition_id_to_revocation_registry[_credential_definition_id].accumulator.accumulator_value = _accumulator_value;
    }


    function getWitnessWithIndex(bytes32 _credential_definition_id,uint _index) internal view returns (uint64) {
        // check if given index is less than size of public witness list
        require(_index < credential_definition_id_to_revocation_registry[_credential_definition_id].public_witness_list.length,"invalid index");
        return credential_definition_id_to_revocation_registry[_credential_definition_id].public_witness_list[_index];
    }

    function getAllWitness(bytes32 _credential_definition_id) internal view returns (uint64[] memory) {
        return credential_definition_id_to_revocation_registry[_credential_definition_id].public_witness_list;
    }


    function updateAllWitness(bytes32 _credential_definition_id,uint64[] memory _public_witness_list) internal isCredentialDefinitionIssuer(_credential_definition_id) {
        credential_definition_id_to_revocation_registry[_credential_definition_id].public_witness_list = _public_witness_list;
    }

}
