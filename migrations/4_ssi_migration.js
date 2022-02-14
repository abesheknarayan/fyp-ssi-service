const Migrations = artifacts.require("SSI");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
