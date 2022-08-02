// SPDX-License-Identifier: none
pragma solidity ^0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "usingtellor/contracts/UsingTellor.sol";

contract DynamicNFT is ERC721, ERC721URIStorage, UsingTellor {

    //storage
    bytes32 public tellorID;
    uint256 public supply;
    mapping(uint256 => uint256) public startPrices;
    string constant metadataURI_up = "ipfs://QmR2zHcNhbM9ps7VQDoa5dHeHZnXzfYYGCma4nvfe6J6V7";
    string constant metadataURI_down = "ipfs://QmR2zHcNhbM9ps7VQDoa5dHeHZnXzfYYGCma4nvfe6J6V7";

    constructor(string memory tokenName,
        string memory symbol,
        bytes32 _tellorID,
        address payable _tellorAddress)
         ERC721(tokenName, symbol) 
         UsingTellor(_tellorAddress)
         {
             tellorID = _tellorID;
    }

    function mintToken(address _owner) public returns (uint256 _id){
        supply++;
        _id = supply;
        (bool ifRetrieve, bytes memory _value,) = getDataBefore(tellorID, block.timestamp - 30 minutes);
        require(ifRetrieve);
        uint256 _uintValue = abi.decode(_value, (uint256));
        startPrices[_id] = _uintValue;
        _safeMint(_owner, _id);
    }

    function updateURI(uint256 _id) external{
        (bool ifRetrieve, bytes memory _value,) = getDataBefore(tellorID, block.timestamp - 30 minutes);
        if (!ifRetrieve) return;
        uint256 _uintValue = abi.decode(_value, (uint256));
        if(_uintValue >= startPrices[_id]){
            _setTokenURI(_id, metadataURI_up);
        }else{
            _setTokenURI(_id, metadataURI_down);
        }
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

/**
  {
    "path": "RedCrest.png",
    "hash": "QmR2zHcNhbM9ps7VQDoa5dHeHZnXzfYYGCma4nvfe6J6V7",
    "size": 124701
  },
  {
    "path": "GreenCrest.png",
    "hash": "QmU1gkk1PiPZm4ewryfgHZ1r3fyzvTrv12UJRJiDmEHju3",
    "size": 178254
  }
]
*/