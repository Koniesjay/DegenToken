// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenGamingToken is ERC20 {
    address public owner;
    uint256 itemCount;

    struct StoreItem {
        uint256 id;
        address itemOwner;
        string name;
        uint256 price;
    }

    address[] public ListOfPlayers;

    mapping(uint256 => StoreItem) public storeItems;

    uint256 public betNum;

    uint256 public betEntryPrice = 1 ether;

    uint256 public betPrice = 1 ether;

    uint256 public starterMint = 3 ether;

    error IncorrectbetEntryPrice();
    error NoParticipants();

    constructor() ERC20("DegenGamingToken", "DGT") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function mint() public onlyOwner {
        _mint(msg.sender, 10 ** 18);
    }

    function bet() public payable {
        if (msg.value != betEntryPrice) {
            revert IncorrectbetEntryPrice();
        }
        ListOfPlayers.push(msg.sender);
    }

    function betWinner() public onlyOwner {
        if (ListOfPlayers.length < 1) {
            revert NoParticipants();
        }
        uint256 randnum = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        uint256 winnerIndex = randnum % ListOfPlayers.length;
        address winner = ListOfPlayers[winnerIndex];
        transfer(winner, betPrice * ListOfPlayers.length);
    }

    function addToStore(string memory _name, uint256 _price) public onlyOwner {
        itemCount++;
        StoreItem storage storeItem = storeItems[itemCount];
        storeItem.id = itemCount;
        storeItem.itemOwner = msg.sender;
        storeItem.name = _name;
        storeItem.price = _price;
    }

    function burn(uint256 value) public {
        require(balanceOf(msg.sender) >= value, "Insufficient balance");
        _burn(msg.sender, value);
    }

    function redeem(uint8 _id) public {
        require(_id <= itemCount, "id is out of bounds");
        transferFrom(msg.sender, storeItems[_id].itemOwner, storeItems[_id].price);
        storeItems[_id].itemOwner = msg.sender;
    }
}
