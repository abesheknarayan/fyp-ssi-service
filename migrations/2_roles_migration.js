const Migrations = artifacts.require("Roles");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
