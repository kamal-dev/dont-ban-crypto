pragma solidity ^0.5.16;
import "./DontBanCrypto.sol";

contract DontBanCryptoSale {

    DontBanCrypto public tokenContract;
    address payable admin;
    uint256 public tokenPrice;
    uint256 public tokenSold;

    event Sell(
        address _buyer,
        uint256 _numberOfTokens
    );

    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x*y) / y == x);
    }

    constructor(DontBanCrypto _tokenContract, uint256 _tokenPrice) public {
        tokenContract = _tokenContract;
        admin = msg.sender;
        tokenPrice = _tokenPrice;
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        // "this" refers to the address of this contract
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens);
        require(msg.value == multiply(_numberOfTokens, tokenPrice));
        require(tokenContract.transfer(msg.sender, _numberOfTokens));
        tokenSold += _numberOfTokens;
        emit Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public {
        require(msg.sender == admin);
        require(tokenContract.transfer(admin,
            tokenContract.balanceOf(address(this))));
        admin.transfer(address(this).balance);
    }

}
