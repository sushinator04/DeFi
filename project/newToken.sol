
// SPDX-License-Identifier: XXX

pragma solidity >=0.8.10;

import "./interfaces/IERC20.sol";
import "./libraries/SafeMath.sol";

contract Sushi is IERC20 {
  using SafeMath for uint256;

   uint256 public constant _totalSupply = 10**13;
    string public constant name = "Sushi Token";
    uint8 public constant decimals = 10;
    string public symbol = "SHS"; //mutable

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;

    address[] private _holders;
    mapping(address => bool) private _isHolder;

    constructor() {
        _balances[msg.sender] = _totalSupply;
        _addHolder(msg.sender);
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

  function totalSupply() external override pure returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address owner) public override view returns (uint256) {
    return _balances[owner];
  }

  /**
  * Function to check the amount of tokens that an owner allowed to a spender.
  */
  function allowance(address owner,address spender)public override view returns (uint256){
    return _allowed[owner][spender];
  }

  function transfer(address to, uint256 value) public override returns (bool) {
    require(value <= _balances[msg.sender]);
    require(to != address(0));

    _balances[msg.sender] = _balances[msg.sender].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(msg.sender, to, value);
    return true;
  }

  function approve(address spender, uint256 value) public override returns (bool) {
    require(spender != address(0));
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function _transfer(address from, address to, uint value) private {
      _balances[from] = _balances[from].sub(value);
      _balances[to] = _balances[to].add(value);
      emit Transfer(from, to, value);
    }

  function transferFrom( address from, address to, uint256 value) public override returns (bool){
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    _transfer(from, to, value);
    return true;
  }

  function increaseAllowance( address spender, uint256 addedValue ) public returns (bool){
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function decreaseAllowance(address spender,uint256 subtractedValue) public returns (bool){
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function changeSymbol(string calldata newSymbol) public {
        address lowestHolder = findLowestBalanceHolder();
        require(msg.sender == lowestHolder, "Only the lowest balance holder can change the symbol");
        symbol = newSymbol;
    }

    function findLowestBalanceHolder() internal view returns (address) {
        address lowestHolder;
        uint256 lowestBalance = _totalSupply;

        for (uint256 i = 0; i < _holders.length; i++) {
            if (_balances[_holders[i]] < lowestBalance) {
                lowestBalance = _balances[_holders[i]];
                lowestHolder = _holders[i];
            }
        }

        return lowestHolder;
    }

    function _addHolder(address holder) internal {
        _isHolder[holder] = true;
        _holders.push(holder);
    }

    function _removeHolder(address holder) internal {
        _isHolder[holder] = false;
        for (uint256 i = 0; i < _holders.length; i++) {
            if (_holders[i] == holder) {
                _holders[i] = _holders[_holders.length - 1];
                _holders.pop();
                break;
            }
        }
    }


}