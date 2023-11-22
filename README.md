# Project Title

Eth+Avax module 4

## Description

This program is a ERC20 token deployed on Avalanche Fuji Testnet and written in Solidity, a programming language used for developing smart contracts on the blockchain. 
Degen Gaming -- DEGEN --- DGN
## Getting Started
The functions are :
1. mintTokens- minting of new tokens (OWNER ONLY)
2. storeItems- addition of new items to the store (OWNER ONLY)
3. getTokenBalance- the acquisition of the desired address' token balance
4. transferTokens- transferring tokens to a desired account
5. transferTokens- transferring tokens to a desired account from a desired account 
6. redeemItem- redeeming items at the store at the cost of tokens
7. burnTokens- burning tokens
8. nftitems- displays the item based on the id
9. owner- shows the address of the owner
10. tokenDecimals - shows the decimal
11. tokenName- shows the token name --- set to Degen
12. tokenSymbol- shows the token symbol --- set to DGN
13. totalTokenSupply- shows the total token supply
### Installing

(1) Make sure you are connected to the Avalanche Fuji Testnet in your Metamask and have some test AVAX.

(2) To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

(3) Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., degencontract.sol). Copy and paste the following code into the file:
```javascript
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
```
(4) To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to latest solidity version (or another compatible version), and then click on the "Compile" button.

(5) After the code is compiled, go to the "Deploy & run transactions" tab and select injected provider as the environment and connect your Metamask account with the test AVAX.

(6) Select the your contract from the dropdown menu, and then click on the "Deploy" button.

(7) Once the contract is deployed, you can interact with it by calling the mint, burn function, redeem, transfer, get balance, etc.

## Authors

Contributors names and contact info

Alijah Ethan Mazo


## License

This project is licensed under the [Alijah Ethan Mazo] License - see the LICENSE.md file for details
