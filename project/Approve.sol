// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;

import "./interfaces/IERC20.sol";

contract ApproveTokens {
    address public router;

    constructor(address _router) public {
        router = _router;
    }

    function approveToken(address token, uint256 amount) external {
        IERC20(token).approve(router, amount);
    }
} 
