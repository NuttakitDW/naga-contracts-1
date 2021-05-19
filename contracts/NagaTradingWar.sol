// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts@3.4.1/access/Ownable.sol";

contract NagaTradingWar is Ownable {
    address payable devaddr;
    uint256 public amount;

    struct Trader {
        address traderAddr;
        uint256 registerBlockTimestamp;
        uint256 balanceOnRegister;
        uint256 value;
        string avatarName;
        string displayName;
        string telegramID;
    }

    mapping(address => Trader) public traderInfo;

    Trader[] public traders;

    // Register event emit
    event Register(
        address _traderAddr,
        uint256 _registerBlockTimestamp,
        uint256 _balanceOnRegister,
        uint256 _value,
        string _avatarName,
        string _displayName,
        string _telegramID
    );

    constructor() public {
        devaddr = msg.sender;
        amount = 0;
    }

    function sizeOfTrader() external view returns (uint256) {
        return traders.length;
    }

    function register(
        string memory _avatarName,
        string memory _displayName,
        string memory _telegramID
        
    ) payable public returns (bool) {
        // To check trader does not exists
        require(
            traderInfo[msg.sender].traderAddr == address(0),
            "Trader address is already exists."
        );

        // To check avatar name is require
        require(bytes(_avatarName).length > 0, "Avatar name is require");

        // To check display name is require
        require(bytes(_displayName).length > 0, "Display name is require");
        
        require(msg.value > 0, "Show me the money");

        Trader memory t =
            Trader(
                msg.sender,
                block.timestamp,
                msg.sender.balance,
                msg.value,
                _avatarName,
                _displayName,
                _telegramID
            );

        traderInfo[msg.sender] = t;

        traders.push(t);

        // Emit Register event
        emit Register(
            msg.sender,
            block.timestamp,
            msg.value,
            msg.sender.balance,
            _avatarName,
            _displayName,
            _telegramID
        );
        
        devaddr.transfer(msg.value);
        
        amount += msg.value;

        return (true);
    }
}