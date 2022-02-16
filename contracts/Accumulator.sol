// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Roles.sol";
import "./CredentialDefinitionRegistry.sol";

/*

Since crypto functions arent compatible yet with solidity , all crypto calculations can be done offline (using another python / nodejs server) and just the calculated value is sent to the smart contracts where it will be stored

Witnesses can be public (in blockchain) but not the hash of any issued credential

Issuer keeps the hash of issued credential with himself and use it for revocation (implementation is not related to blockchain and in our case it can be done as a part of wallet using db)

Accumulator logic: (needs to be checked !!!!)

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


Possible non-revocation proof using sigma protocol:

Indentity Holder - I
Verifier - V

I gives a commitment for a public witness W as well as W.
V can check if witness is present in the blockchain.
Then I will give zkp for his credential revocation using given commitment of witness.

A decent zkp flow: (needs to be checked !!!)
public Witness W = g^(k) where k is private witness
prover chooses a random number r1 and computes C1 = W^r1 => g^(kr1)
prover chooses a random number r2 to compute C2 =  g^(xr2) where x is the H(revocation id)
prover also gives kr1,xr2,C1,C2,W. Hard to compute k and x from kr1,xr2 (Factorization problem RSA)
verifier will check the commitments and will see if W is in blockchain
then verifier will check if g^(accumulator*r1*r2) = (g^(kr1))^(xr2)
*/




contract Accumulator is Roles, CredentialDefinitionRegistry {
    int256 prime;
    int256 accumulator_value;
    bytes32 credentialSchemaHash;

    // witness list as mapping cannot be iterated. Solidity sucks   
    int256[] witness_list;

    // only credential owner can call functions related to that credential
    modifier isCredentialIssuer() {
        require(
            credential_definition_hash_to_issuer_entity_address_hash[
                credentialSchemaHash
            ] == keccak256(abi.encodePacked(msg.sender))
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

    // anyone including the verifier can call this function to see if given witness is part of set of witnesses. Revealing witness doesnt reveal anything related to credential
    function getAllWitness() public view returns (int256[] memory) {
        return witness_list;
    }


    // happens during revocation / issuance of credential
    function updateAllWitness(int256[] memory _witness_array) internal isCredentialIssuer {
        delete witness_list;
        for(uint i=0;i<_witness_array.length;i++){
            witness_list.push(_witness_array[i]);
        }
    }

}
