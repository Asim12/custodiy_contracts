const {expect}      =   require("chai");
const { concat }    =   require("ethers/lib/utils");
const {ethers}      =   require("hardhat");
const web3          =   require("web3")
require('dotenv').config();
require("@nomiclabs/hardhat-waffle");
const { TOTAL_RESERVE, MINT_LIMIT , NAME, SYMBOL} = process.env;
describe("Working on mintOgre Contract unit test", async() => {
    it('reserveForTeam function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("ogreTown");
        const nft = await NFT.deploy(
            MINT_LIMIT,
            TOTAL_RESERVE,
            NAME,
            SYMBOL
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const tx = await contract.reserveForTeam(1)
        console.log('tx', tx);
        expect(tx.confirmations).to.equal(1);
    });

    it('mintOgre function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("OgreTown");
        const nft = await NFT.deploy(
            MINT_LIMIT,
            TOTAL_RESERVE,
            NAME,
            SYMBOL
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);

        const publoicSaleMakeTrue = await contract.setpublicSale(true);
        console.log("publoicSaleMakeTrue", publoicSaleMakeTrue)
        const tx = await contract.mintOgre(1)
        console.log('tx', tx)  
        expect(tx.confirmations).to.equal(1)
    });

    it('setpublicSale function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("OgreTown");
        const nft = await NFT.deploy(
            MINT_LIMIT,
            TOTAL_RESERVE,
            NAME,
            SYMBOL
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const publicSale = await contract.setpublicSale(true)
        console.log('publicSale', publicSale)  
        expect(publicSale.confirmations).to.equal(1)
    });


    it('setRevealNft function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("OgreTown");
        const nft = await NFT.deploy(
            MINT_LIMIT,
            TOTAL_RESERVE,
            NAME,
            SYMBOL
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const setRevealNft = await contract.setRevealNft(true)
        console.log('setRevealNft', setRevealNft)  
        expect(setRevealNft.confirmations).to.equal(1)
    });

    it('setProvenanceHash function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("OgreTown");
        const nft = await NFT.deploy(
            MINT_LIMIT,
            TOTAL_RESERVE,
            NAME,
            SYMBOL
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const setProvenanceHash = await contract.setProvenanceHash("aisnsldnslcfjsdkjcjsd")
        console.log('setProvenanceHash', setProvenanceHash)  
        expect(setProvenanceHash.confirmations).to.equal(1)
    });

    it('setBaseURI function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("OgreTown");
        const nft = await NFT.deploy(
            MINT_LIMIT,
            TOTAL_RESERVE,
            NAME,
            SYMBOL
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const setBaseURI = await contract.setBaseURI("aisnsldnslcfjsdkjcjsd")
        console.log('setBaseURI', setBaseURI)  
        expect(setBaseURI.confirmations).to.equal(1)
    });


    it('setPlaceholderURI function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("OgreTown");
        const nft = await NFT.deploy(
            MINT_LIMIT,
            TOTAL_RESERVE,
            NAME,
            SYMBOL
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const setPlaceholderURI = await contract.setPlaceholderURI("aisnsldnslcfjsdkjcjsd")
        console.log('setPlaceholderURI', setPlaceholderURI)  
        expect(setPlaceholderURI.confirmations).to.equal(1)
    });
})
