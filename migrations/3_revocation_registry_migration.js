const Migrations = artifacts.require("RevocationRegistry");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
