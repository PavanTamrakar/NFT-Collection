// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract GandhiMoney is ERC721Enumerable, Ownable {
    string _baseTokenURI;

    IWhitelist whitelist;

    bool public presaleStarted;

    uint256 public maxTokenIds = 20;

    uint256 public tokenIds;

    uint256 public _price = 0.01 ether;

    bool public _paused;

    modifier onlyWhenNotPaused{
        require (!_paused, "Currently Paused");
        _;
    }

    constructor(string memory baseURI, address whitelistAddress)ERC721("Gandhi Money", "GM") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale () public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint () public payable {
        require(presaleStarted && block.timestamp < presaleEnded, "PreSale Ended");
        require(whitelist.WhitelistedAddresses(msg.sender), "Not in the Whitelis");
        require(tokenIds < maxTokenIds, "Eceeded the limit");
        require(msg.value >= _price);
        tokenIds =+ 1;

        _safeMint(msg.sender, tokenIds);

    }

    function mint () public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >= presaleEnded, "PreSale Ended");
        require(whitelist.WhitelistedAddresses(msg.sender), "Not in the Whitelis");
        require(tokenIds < maxTokenIds, "Eceeded the limit");
        require(msg.value >= _price);
        tokenIds =+ 1;

        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
        uint256 amount = address(this).balance;
        (bool, sent) = _owner.call{value: amount}("");
        require(condition);
    }

    function setPaused(bool val) public onlyOwner{
        _paused = val;
    } 

    function withdraw() public onlyOwner{
        address _owner = owner();

    }

    receive() external payable{}

    fallback() external payable{}
}
