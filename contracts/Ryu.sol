// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./lib/ERC2981PerTokenRoyalties.sol";

contract Ryu is
    Initializable,
    UUPSUpgradeable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    OwnableUpgradeable,
    ERC2981PerTokenRoyalties
{
    using Strings for uint256;
    string baseUri;

    mapping(uint256 => bool) public isLegends;
    mapping(uint256 => uint256) public imagesID;

    function initialize()
        public
        initializer
    {
        __ERC721_init("Ryu NFTs", "RYU");
        __ERC721Enumerable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();

        baseUri = "ipfs://QmShG5SvTx4bkUNTpVNwQKkEMhcyM5SmbfQSTGy7sZ9L9S/";
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    function getInterfaceID_IERC721() public pure returns (bytes4) {
        return type(IERC721Upgradeable).interfaceId;
    }

    function getInterfaceID_Metadata() public pure returns (bytes4) {
        return type(IERC721MetadataUpgradeable).interfaceId;
    }

    function isLegend(uint256 _tokenId) public view returns (bool) {
        if (isLegends[_tokenId]) return true;
        else return false;
    }

    function airdrop(
        uint256 tokenID,
        address receiver,
        uint256 _imageId,
        bool _isLegend
    ) internal {
        isLegends[tokenID] = _isLegend;
        imagesID[tokenID] = _imageId;
        _safeMint(receiver, tokenID);
    }

    function setIsLegend(uint256 tokenId, bool newIsLegend) external onlyOwner {
        isLegends[tokenId] = newIsLegend;
    }

    function airdrops(
        uint256[] calldata tokenIDs,
        address[] calldata receivers,
        uint256[] calldata _imageIds,
        bool[] calldata _isLegends
    ) external onlyOwner {
        for (uint256 i=0; i < tokenIDs.length; i++){
            airdrop(tokenIDs[i], receivers[i], _imageIds[i], _isLegends[i]);
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();
        uint256 imageID = imagesID[tokenId];
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, imageID.toString(), ".json"))
                : "";
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        _safeTransfer(from, to, tokenId, _data);
    }

    function setBaseUri(string memory uri) external onlyOwner {
        baseUri = uri;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override(ERC2981Base, ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        bytes4 _INTERFACE_ID_ERC721 = 0x80ac58cd;
        bytes4 _INTERFACE_ID_METADATA = 0x5b5e139f;
        bytes4 _INTERFACE_ID_ERC2981 = 0x2a55205a;

        return (interfaceId == _INTERFACE_ID_ERC2981 ||
            interfaceId == _INTERFACE_ID_ERC721 ||
            interfaceId == _INTERFACE_ID_METADATA);
    }

    receive() external payable {}

    fallback() external payable {}
}
