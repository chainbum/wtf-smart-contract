//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WebTimeFolks is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string private baseURI;
    string private notRevealedUri;
    string private baseExtension = ".json";

    bool public isWhiteListSaleActive = false;
    bool public isPublicSaleActive = false;
    bool public revealed = false;

    uint256 public MAX_SUPPLY = 10000;
    uint256 public PRICE = 0.08 ether;
    uint256 public MAX_MINT_AMOUNT = 5;

    mapping(address => uint8) private _whiteList;

    constructor(string memory _initBaseURI, string memory _initNotRevealedUri) ERC721("WebTimeFolks", "WTF") {
        setBaseURI(_initBaseURI);
        setNotRevealedURI(_initNotRevealedUri);
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setIsWhiteListSaleActive(bool _isWhiteListActive) external onlyOwner {
        isWhiteListSaleActive = _isWhiteListActive;
    }

    function setIsPublicSaleActive(bool _isPublicSaleActive) external onlyOwner {
        isPublicSaleActive = _isPublicSaleActive;
    }

    function setRevealed(bool _revealed) external onlyOwner {
        revealed = _revealed;
    }

    function setPrice(uint256 _price) external onlyOwner {
        PRICE = _price;
    }

    function setWhiteList(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            _whiteList[addresses[i]] = numAllowedToMint;
        }
    }

    function getNumAvailableToMint(address addr) external view returns (uint8) {
        return _whiteList[addr];
    }

    function getIsWhiteListSaleActive() external view returns (bool) {
        return isWhiteListSaleActive;
    }

    function getIsPublicSaleActive() external view returns (bool) {
        return isPublicSaleActive;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function mintWhiteList(uint8 numberOfTokens) external payable {
        uint256 supply = totalSupply();
        require(isWhiteListSaleActive, "WL is not active");
        require(numberOfTokens <= _whiteList[msg.sender], "Don't be greedy!");
        require(supply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(PRICE * numberOfTokens <= msg.value, "ETH sent is not correct");

        _whiteList[msg.sender] -= numberOfTokens;
        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function mintPublic(uint256 numberOfTokens) external payable {
        uint256 supply = totalSupply();
        require(isPublicSaleActive, "Public sale is not active");
        require(numberOfTokens <= MAX_MINT_AMOUNT, "Don't be greedy!");
        require(supply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(PRICE * numberOfTokens <= msg.value, "ETH sent is not correct");


        for (uint256 i = 1; i <= numberOfTokens; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Inexistent Token ID");

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function reserve(uint256 n) external onlyOwner {
        uint supply = totalSupply();
        uint i;
        for (i = 0; i < n; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}