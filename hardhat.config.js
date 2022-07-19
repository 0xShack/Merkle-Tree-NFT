require("dotenv").config();
require("@nomiclabs/hardhat-waffle");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 const { ALCHEMY_RINKEBY_API_KEY, PRIVATE_KEY } = process.env;
 module.exports = {
   solidity: {
     compilers: [
        {
          version: "0.8.0"
        },
        {
          version: "0.8.1"
        }
     ]
   },
   networks: {
     hardhat: {

     },
     rinkeby: {
       url: "https://eth-rinkeby.alchemyapi.io/v2/" + ALCHEMY_RINKEBY_API_KEY,
       accounts: [PRIVATE_KEY]
     }
   }
 };
