import { expect } from "chai"
import { getAddress, parseUnits } from "viem"
import hre from "hardhat"
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers"

describe("GiftExchange", function () {
  async function deployFixture() {
    const [owner, player1, player2, player3, player4, player5] =
      await hre.viem.getWalletClients()

    console.log("deploying tokens")
    const tokenA = await hre.viem.deployContract("TestToken", [
      "TokenA",
      "USDT",
      6,
    ])
    const tokenB = await hre.viem.deployContract("TestToken", [
      "TokenB",
      "USDC",
      6,
    ])
    const tokenC = await hre.viem.deployContract("TestToken", [
      "TokenC",
      "DAI",
      18,
    ])
    const tokenD = await hre.viem.deployContract("TestToken", [
      "TokenD",
      "LINK",
      18,
    ])
    const tokenE = await hre.viem.deployContract("TestToken", [
      "TokenE",
      "BOB",
      18,
    ])

    console.log("deployed tokens")

    await tokenA.write.transfer([owner.account.address, parseUnits("10", 6)])
    await tokenB.write.transfer([owner.account.address, parseUnits("10", 6)])
    await tokenC.write.transfer([owner.account.address, parseUnits("10", 6)])

    await tokenA.write.transfer([player1.account.address, parseUnits("10", 6)])
    await tokenB.write.transfer([player2.account.address, parseUnits("10", 6)])
    await tokenC.write.transfer([player3.account.address, parseUnits("10", 18)])
    await tokenD.write.transfer([player4.account.address, parseUnits("10", 18)])
    await tokenE.write.transfer([player5.account.address, parseUnits("10", 18)])

    console.log("fauceted tokens")

    const giftExchange = await hre.viem.deployContract("GiftExchange")

    const publicClient = await hre.viem.getPublicClient()

    return {
      giftExchange,
      tokenA,
      tokenB,
      tokenC,
      tokenD,
      tokenE,
      owner,
      player1,
      player2,
      player3,
      player4,
      player5,
      publicClient,
    }
  }

  describe("Deployment", function () {
    it("Should match init states", async function () {
      const {
        giftExchange,
        owner,
        tokenA,
        tokenB,
        tokenC,
        player1,
        player2,
        player3,
      } = await loadFixture(deployFixture)

      expect(await giftExchange.read.owner()).to.equal(
        getAddress(owner.account.address)
      )

      expect(await tokenA.read.balanceOf([player1.account.address])).to.equal(
        parseUnits("10", 6)
      )

      expect(await tokenB.read.balanceOf([player2.account.address])).to.equal(
        parseUnits("10", 6)
      )

      expect(await tokenC.read.balanceOf([player3.account.address])).to.equal(
        parseUnits("10", 18)
      )
    })

    // TODO:
    // it("Play the game", async function () {
    //   const {
    //     giftExchange,
    //     owner,
    //     tokenA,
    //     tokenB,
    //     tokenC,
    //     player1,
    //     player2,
    //     player3,
    //   } = await loadFixture(deployFixture)

    // })
  })
})
