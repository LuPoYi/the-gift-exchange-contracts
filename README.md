### Sepolia contracts

- USDT: 0x419Fe9f14Ff3aA22e46ff1d03a73EdF3b70A62ED
- LINK: 0x779877A7B0D9E8603169DdbD7836e478b4624789
- USDC: 0x13fA158A117b93C27c55b8216806294a0aE88b6D
- EURC: 0x08210f9170f89ab7658f0b5e3ff39b0e03c594d4

- contract: 0xa8a3f55638c121eb84f079cec54f418a5d55e789

### TODO:

- fake random to chainlink VRF - but might need to change logic casue chainlink random number will be async
- hardhat test

##### Depoloyed ChainLink VRFv2Consumer

- TX: https://sepolia.etherscan.io/tx/0x8bad86fc1e7b7da29de169e071e826e38d7988e9069e7d946eb198066ccbe810
- Contract: https://sepolia.etherscan.io/address/0xa8a3f55638c121eb84f079cec54f418a5d55e789

#### command

- `cast call --rpc-url=https://sepolia.infura.io/v3/fdc4e136386f4d51aa4ae5cf19242c05 0xa8a3f55638c121eb84f079cec54f418a5d55e789 's_requestId()'`

- `cast call --rpc-url=https://sepolia.infura.io/v3/fdc4e136386f4d51aa4ae5cf19242c05 0xa8a3f55638c121eb84f079cec54f418a5d55e789 's_randomWords(uint256)' 1`

- `cast send --rpc-url=https://sepolia.infura.io/v3/fdc4e136386f4d51aa4ae5cf19242c05 0xa8a3f55638c121eb84f079cec54f418a5d55e789 'requestRandomWords()' --private-key=$METAMASK_TEST_KEY`
