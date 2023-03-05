//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

/*
IPFS SERVER UPLOAD IMAGE
F:\Blockchain\NFTIntegration\nft-collectible>ipfs add 1.jpg
 399.58 KiB / 399.58 KiB [====================================================================================] 
 100.00%←added QmThzTt9dYH1UEpZV5gAgjQKZkcYKdpfjpfXFWAor2bHVQ 1.jpg
 399.58 KiB / 399.58 KiB [====================================================================================] 100.00%
F:\Blockchain\NFTIntegration\nft-collectible>ipfs add nft.json
 176 B / 176 B [==============================================================================================] 
 100.00%←added QmNxvxJCz9ByuDpL4rK3ZBER1NPYEmQw1MJoThb1tYdSzE nft.json
 176 B / 176 B [==============================================================================================] 100.00%
F:\Blockchain\NFTIntegration\nft-collectible>

https://ipfs.io/ipfs/QmNxvxJCz9ByuDpL4rK3ZBER1NPYEmQw1MJoThb1tYdSzE/1
*/
contract NFTCollectible is ERC721Enumerable , Ownable{
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    uint public constant MAX_SUPPLY = 100; //The maximum number of NFTs that can be minted in your collection.
    uint public constant PRICE = 0.01 ether;//The amount of ether required to buy 1 NFT.
    uint public constant MAX_PER_MINT = 5;//The upper limit of NFTs that you can mint at once.
    //We will write a setter function for baseTokenURI that will allow the contract’s owner (or deployer)
    // to change the base URI as and when required.
    string public baseTokenURI;//The IPFS URL of the folder containing the JSON metadata.

    constructor(string memory baseURI) ERC721("NFT Collectible","NFTC"){
        setBaseURI(baseURI);
    }
    function _baseURI() internal 
                        view 
                        virtual 
                        override 
                        returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
       
    }
    function reserveNFTs() public onlyOwner {     //token minting
        uint totalMinted = _tokenIds.current();
        require(
            totalMinted.add(3) < MAX_SUPPLY, "Not enough NFTs"
        );
        for (uint i = 0; i < 3; i++) {
            _mintSingleNFT();
        }
    }
    function mintNFTs(uint _count) public payable {   // checking and miniting to spender(purchaser)
        uint totalMinted = _tokenIds.current();
        require(
        totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFTs!"
        );
        require(
        _count > 0 && _count <= MAX_PER_MINT, 
        "Cannot mint specified number of NFTs."
        );
        require(
        msg.value >= PRICE.mul(_count), 
        "Not enough ether to purchase NFTs."
        );
        for (uint i = 0; i < _count; i++) {
                _mintSingleNFT();
        }
    }
    function _mintSingleNFT() private { // that’s being called whenever we (or a third party) want to mint an NFT.
      uint newTokenID = _tokenIds.current(); //hasn’t been minted yet
      //_safeMint called first time ,newTokenID = 0
      _safeMint(msg.sender, newTokenID);//assign the NFT ID to the account that called the function
      _tokenIds.increment();
    }
    //Getting all tokens owned by a particular account
    //if you wanna know which NFTs from your collection each user holds.
    function tokensOfOwner(address _owner) 
            external 
            view 
            returns (uint[] memory) {
        uint tokenCount = balanceOf(_owner);//how many tokens a particular owner holds
        uint[] memory tokensId = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i); //get all the IDs that an owner owns.
        }

        return tokensId;
    }
    function withdraw() public payable onlyOwner {
        uint balance = address(this).balance; //retrieve the amount of Ether hold
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }

}