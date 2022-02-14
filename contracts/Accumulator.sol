// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Roles.sol";

contract Accumulator is Roles {
    int256 prime;
    int256 accumulator_value;

    // key is the hash of issued credential mapped to its witness
    mapping(string => int256) credentialHash_to_witness;

    // adds a new cred hash to accumulator
    function updateOnAdd(string _credentialHash)
        internal
        onlyStewardOrTrustAnchor
    {
        _;
    }

    // removes the hash from accumulator
    function updateOnRevoke(string _credentialHash)
        internal
        onlyStewardOrTrustAnchor
    {
        _;
    }

    function getWitness(string _credentialHash) internal view returns (int256) {
        return credentialHash_to_witness(_credentialHash);
    }
}
