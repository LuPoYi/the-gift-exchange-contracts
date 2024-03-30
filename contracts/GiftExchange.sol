// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20Decimals is IERC20 {
    function decimals() external view returns (uint8);
}

contract GiftExchange is Ownable(msg.sender) {
    struct TokenInfo {
        address tokenAddress;
        uint8 decimals;
        string symbol;
        uint humanReadableAmount;
    }

    address[] public players;
    TokenInfo[] public prizeTokenInfos;

    uint constant NUM_PRIZE_POOLS = 3; // Number of prize pools
    uint constant PRIZE_AMOUNT = 1; // Prize amount (1 tokens)

    event PrizeClaimed(
        address indexed player,
        uint indexed pool,
        uint amount,
        string symbol,
        uint humanReadableAmount
    );
    event PrizePoolInitialized(
        uint indexed pool,
        address token,
        uint amount,
        string symbol,
        uint humanReadableAmount
    );
    event PlayerPlayed(
        address indexed player,
        uint indexed pool,
        uint amount,
        string symbol,
        uint humanReadableAmount
    );

    // play also include initialize
    function play(address token) external {
        require(token != address(0), "Invalid token address");
        IERC20Metadata tokenMetadata = IERC20Metadata(token);
        uint8 decimals = tokenMetadata.decimals();
        string memory symbol = tokenMetadata.symbol();
        uint amount = PRIZE_AMOUNT * (10 ** uint(decimals));

        // Scenario 1: Initialize prize pools if they're not all set up yet
        if (prizeTokenInfos.length < NUM_PRIZE_POOLS) {
            // Initialize prize pool
            prizeTokenInfos.push(
                TokenInfo({
                    tokenAddress: token,
                    decimals: decimals,
                    symbol: symbol,
                    humanReadableAmount: PRIZE_AMOUNT
                })
            );
            players.push(msg.sender); // Assume the initializer is also a player

            // Transfer tokens to the contract
            IERC20(token).transferFrom(msg.sender, address(this), amount);

            emit PrizePoolInitialized(
                prizeTokenInfos.length - 1,
                token,
                amount,
                symbol,
                PRIZE_AMOUNT
            );
        } else {
            // Scenario 2: All prize pools are set, proceed with the game
            uint randomIndexForPlayer = uint(
                keccak256(abi.encodePacked(block.timestamp, msg.sender))
            ) % players.length;
            uint randomIndexForPrize = uint(
                keccak256(abi.encodePacked(block.prevrandao, block.timestamp))
            ) % prizeTokenInfos.length;

            require(
                players[randomIndexForPlayer] != address(0),
                "Random player address is invalid."
            );
            require(
                prizeTokenInfos[randomIndexForPrize].tokenAddress != address(0),
                "Random prize info is invalid."
            );

            address playerA = players[randomIndexForPlayer];
            TokenInfo memory prizeA = prizeTokenInfos[randomIndexForPrize];

            uint prizeAmount = prizeA.humanReadableAmount *
                (10 ** uint(prizeA.decimals));

            // transfer prize to winner
            if (playerA != address(0)) {
                IERC20(prizeA.tokenAddress).transfer(playerA, prizeAmount);
                emit PrizeClaimed(
                    playerA,
                    randomIndexForPrize,
                    prizeAmount,
                    prizeA.symbol,
                    prizeA.humanReadableAmount
                );
            }

            // transfer token from current player to contract
            IERC20(token).transferFrom(msg.sender, address(this), amount);

            // update contract state
            players[randomIndexForPlayer] = msg.sender;
            prizeTokenInfos[randomIndexForPrize] = TokenInfo({
                tokenAddress: token,
                decimals: uint8(decimals),
                symbol: symbol,
                humanReadableAmount: PRIZE_AMOUNT
            });

            emit PlayerPlayed(
                msg.sender,
                randomIndexForPrize,
                amount,
                symbol,
                PRIZE_AMOUNT
            );
        }
    }
}
