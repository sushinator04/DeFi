// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;


//i have imported copies of your interfaces provided on github
import "./interfaces/IERC20.sol";
import "./interfaces/IRouter.sol";
import "./interfaces/IWETH.sol";


contract AddLiquidity {
    IUniswapV2Router01 public router;

    //my 3 tokens to trade
    address public sushiToken;
    address public weth;
    address public defiToken;


    constructor(address _router, address _sushiToken, address _weth, address _defiToken) {
        router = IUniswapV2Router01(_router);
        sushiToken = _sushiToken;
        weth = _weth;
        defiToken = _defiToken;
    }

    function addLiquidity(
        uint256 sushiAmount,
        uint256 wethAmount,
        uint256 sushiMin,
        uint256 wethMin,
        uint256 deadline
    ) external {

        // Transfer Sushi tokens from the sender to this contract
        IERC20(sushiToken).transferFrom(msg.sender, address(this), sushiAmount);
        // Transfer WETH tokens from the sender to this contract
        IERC20(weth).transferFrom(msg.sender, address(this), wethAmount);

        // Approve the router to spend the Sushi tokens
        IERC20(sushiToken).approve(address(router), sushiAmount);
        // Approve the router to spend the WETH tokens
        IERC20(weth).approve(address(router), wethAmount);

        // Add liquidity to the Sushi-WETH pool
        router.addLiquidity(
            sushiToken,
            weth,
            sushiAmount,
            wethAmount,
            sushiMin, //min amount i want
            wethMin,
            msg.sender,
            deadline //deadline
        );
    }

    //same but with Defi
    function addLiquidityWithDefi(uint256 sushiAmount,
        uint256 defiAmount,
        uint256 sushiMin,
        uint256 defiMin,
        uint256 deadline
    ) external {
        // Transfer Sushi tokens from the sender to this contract
        IERC20(sushiToken).transferFrom(msg.sender, address(this), sushiAmount);
        // Transfer DEFI tokens from the sender to this contract
        IERC20(defiToken).transferFrom(msg.sender, address(this), defiAmount);

        // Approve the router to spend the Sushi tokens
        IERC20(sushiToken).approve(address(router), sushiAmount);
        // Approve the router to spend the DEFI tokens
        IERC20(defiToken).approve(address(router), defiAmount);

        // Add liquidity to the Sushi-DEFI pool
        router.addLiquidity(
            sushiToken,
            defiToken,
            sushiAmount,
            defiAmount,
            sushiMin,
            defiMin,
            msg.sender,
            deadline
        );
    }
}
