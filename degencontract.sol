// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DegenToken {
    address public owner;
    string public tokenName;
    string public tokenSymbol;
    uint8 public tokenDecimals;
    uint256 public totalTokenSupply;

    constructor() {
        owner = msg.sender;
        tokenName = "Degen";
        tokenSymbol = "DGN";
        tokenDecimals = 10;
        totalTokenSupply = 0;
        storeItems(0, "Smoke Wallet $50", 50);
        storeItems(1, "Smoke Wallet $100", 100);
        storeItems(2, "Smoke Wallet $200", 200);
        storeItems(3, "Smoke Wallet $250", 250);
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "This function can only be used by the owner.");
        _;
    }

    mapping(address => uint256) private tokenBalances;
    mapping(address => mapping(address => uint256)) private tokenAllowances;
    mapping(uint256 => Nft) public nftItems;

    struct Nft {
        string itemName;
        uint256 itemPrice;
    }

    function storeItems(uint256 itemId, string memory itemName, uint256 itemPrice) public ownerOnly {
        nftItems[itemId] = Nft(itemName, itemPrice);
    }

    event mint(address indexed to, uint256 value);
    event approval(address indexed tokenOwner, address indexed spender, uint256 value);
    event transfer(address indexed from, address indexed to, uint256 value);
    event burn(address indexed from, uint256 value);
    event redeem(address indexed from, string itemName);

    function mintTokens(address to, uint256 amount) external ownerOnly {
        totalTokenSupply += amount;
        tokenBalances[to] += amount;

        emit mint(to, amount);
        emit transfer(address(0), to, amount);
    }

    function getTokenBalance(address accountAddress) external view returns (uint256) {
        return tokenBalances[accountAddress];
    }

    function transferTokens(address receiver, uint256 amount) external returns (bool) {
        require(tokenBalances[msg.sender] >= amount, "Insufficient Funds");

        tokenBalances[msg.sender] -= amount;
        tokenBalances[receiver] += amount;

        emit transfer(msg.sender, receiver, amount);
        return true;
    }

    function transferTokensFrom(address sender, address receiver, uint256 amount) external returns (bool) {
        require(tokenBalances[msg.sender] >= amount, "Insufficient Funds");
        require(tokenAllowances[sender][msg.sender] >= amount, "Insufficient Funds");

        tokenBalances[sender] -= amount;
        tokenBalances[receiver] += amount;
        tokenAllowances[sender][msg.sender] -= amount;

        emit transfer(sender, receiver, amount);
        return true;
    }

    function burnTokens(uint256 amount) external {
        require(amount <= tokenBalances[msg.sender], "Insufficient Funds");

        tokenBalances[msg.sender] -= amount;
        totalTokenSupply -= amount;

        emit burn(msg.sender, amount);
        emit transfer(msg.sender, address(0), amount);
    }

    function redeemItem(uint256 accId) external returns (string memory) {
        require(tokenBalances[msg.sender] > 0, "Insufficient Funds");
        require(nftItems[accId].itemPrice > 0, "Invalid item ID.");

        uint256 redemptionAmount = nftItems[accId].itemPrice;
        require(tokenBalances[msg.sender] >= redemptionAmount, "Balance should be equal to or more than the item to redeem it.");

        tokenBalances[msg.sender] -= redemptionAmount;

        emit redeem(msg.sender, nftItems[accId].itemName);

        return nftItems[accId].itemName;
    }
}
