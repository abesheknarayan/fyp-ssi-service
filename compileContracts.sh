# bash script for compiling contracts and placing them onto both
echo "...building contracts with reset flag..."
echo "...clears all the contract transactions..."
truffle deploy --reset
cp -R contracts-build fyp-clients/issuer-portal/frontend/src
cp -R contracts-build fyp-clients/wallet/src
cp -R contracts-build fyp-clients/verifier-portal/frontend/src
cp -R contracts-build fyp-clients/verifier-portal/backend/src
