import '@nomicfoundation/hardhat-toolbox-viem';

import { HardhatUserConfig, vars } from 'hardhat/config';

const INFURA_API_KEY = vars.get("INFURA_API_KEY")
const SEPOLIA_PRIVATE_KEY = vars.get("SEPOLIA_PRIVATE_KEY")

const config: HardhatUserConfig = {
  // defaultNetwork: "sepolia",
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
    hardhat: {
      forking: {
        url: 'https://eth.llamarpc.com',
      },
    },
  },
}

export default config
