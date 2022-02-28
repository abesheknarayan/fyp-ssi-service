# bash script for compiling contracts and placing them onto both
echo "...building contracts..."
truffle compile
truffle deploy
cp -R contracts-build fyp-clients/issuer-portal/frontend/src
cp -R contracts-build fyp-clients/wallet/src
cp -R contracts-build fyp-clients/verifier-portal/frontend/src
