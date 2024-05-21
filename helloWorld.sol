// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

// Import the SafeMath library from OpenZeppelin
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SushiToken {
    using SafeMath for uint256;

    uint256 public constant totalSupply = 10**13; // Total supply of the token
    string public constant name = 'Sushi Token'; // Name of the token
    uint8 public constant decimals = 10; // Token's divisibility
    string public constant symbol = 'SUSHI'; // Symbol of the token

    mapping(address => uint256) private balance; // Associates addresses to their token balances


    constructor() {
        balance[msg.sender] = totalSupply; // Assigns the entire supply to the contract creator
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= balance[msg.sender], "Insufficient balance"); // Ensure the sender has enough tokens
        require(to != address(0), "Invalid address"); // Ensure the recipient address is valid

        // Use SafeMath for safe arithmetic operations
        balance[msg.sender] = balance[msg.sender].sub(value); // Deduct tokens from the sender's balance
        balance[to] = balance[to].add(value); // Add tokens to the recipient's balance


        return true; // Indicate that the transfer was successful
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balance[owner]; // Return the balance of the specified address
    }
}

