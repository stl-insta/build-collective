pragma solidity >=0.4.22 <0.9.0;

contract Ownable {
  address public owner = msg.sender;

  modifier restricted() {
    require(msg.sender == owner, "Function restricted to contracts’s owner");
    _;
  }

  modifier onlyOwner(uint _itemId, mapping (uint => address) memory _itemToOwnerList) {
    require(_itemToOwnerList[_itemId] == owner);
    _;
  }
}
