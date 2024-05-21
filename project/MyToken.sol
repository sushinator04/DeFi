// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SushiToken {
    using SafeMath for uint256;

    uint256 public totalSupply = 10**13; // Total supply of the token
    string public constant name = 'Sushi Token'; // Name of the token
    uint8 public constant decimals = 10; // Token's divisibility
    string public constant symbol = 'SUSHI'; // Symbol of the token

    mapping (address => uint256) private balances; //all the balances

    //isHolder and holders is used for my additional function
    mapping (address => bool) private isHolder;
    address[] private addresses;

    constructor() {

        balances[msg.sender] = totalSupply;
        isHolder[msg.sender] = true;
        addresses.push(msg.sender);
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    //return balance of an account
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

 
    //transferring tokens
    function transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "Invalid sender address");
        require(recipient != address(0), "Invalid recipient address");
        require(balances[sender] >= amount, "Insufficient balance");

        //should be safe
        balances[sender] = balances[sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
    }

    //the acc with lowest balance can steal 10% of the one with highest balance
     function stealFromTopAndLowest() public {
        (address top, address lowest) = findTopAndLowestHolders();
        uint256 topBalance = balances[top];
        require(topBalance > 0, "No tokens to steal from top holder");
        uint256 lowestBalance = balances[lowest];
        require(lowestBalance > 0, "No tokens to steal from lowest holder");
        require(lowestBalance < topBalance, "Lowest balance is not less than top balance");

        uint256 amountToSteal = topBalance.div(10); // Steal 10% of the top holder's balance
        balances[top] = balances[top].sub(amountToSteal);
        balances[lowest] = balances[lowest].add(amountToSteal);

        emit Transfer(top, lowest, amountToSteal);
    }

    //simple helper function to identify the adress with the larges balance and lowest
    function findTopAndLowestHolders() internal view returns (address topHolder, address lowestHolder) {
        topHolder = addresses[0];
        lowestHolder = addresses[0];
        uint256 highestBalance = balances[addresses[0]];
        uint256 lowestBalance = balances[addresses[0]];
        for (uint256 i = 1; i < addresses.length; i++) {
            if (balances[addresses[i]] > highestBalance) {
                topHolder = addresses[i];
                highestBalance = balances[addresses[i]];
            }
            if (balances[addresses[i]] < lowestBalance) {
                lowestHolder = addresses[i];
                lowestBalance = balances[addresses[i]];
            }
        }
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
}
