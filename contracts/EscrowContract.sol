// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; 
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; 
import "hardhat/console.sol";
contract EscrowContract is ReentrancyGuard{
    using SafeERC20 for IERC20;
    address public contractOwner;
    mapping(address => bool) private approvers;
    mapping(uint256 => LockedToken) private lockedTokens;
    uint256 public transactionIdCounter;
    struct LockedToken {
        uint256 transactionId;
        address sender;
        address recipient;
        address tokenAddress;
        uint256 amount;
        bool claimed;
        bool approved;
        address approvalAddress;
        string date;
        string filePath;
        string _type;
    }
    event TokenLocked(uint256 indexed transactionId, address indexed sender, address indexed recipient, address tokenAddress, uint256 amount, address _approvers);
    event TokensClaimed(uint256 indexed transactionId, address indexed recipient, uint256 amount);
    event BnbClaimed(uint256 indexed transactionId, address indexed recipient, uint256 amount);
    event TransactionApproved(uint256 indexed transactionId, bool approved);
    event TransactionRevert(uint256 indexed transactionId, bool status);
    constructor() {
        contractOwner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Only the contract owner can call this function");
        _;
    }

    function _transferOwnership(address newOwner) public onlyOwner {
        contractOwner = newOwner;
    }

    function lockBnb(address _recipient, address _approvers, string memory _date, string memory _filePath) public payable {
        require(msg.value > 0, "Amount must be greater than zero");
        require(_recipient != address(0), "Invalid recipient address");
        require(_approvers != address(0), "Invalid recipient address");
        uint256 newTransactionId = transactionIdCounter;
        lockedTokens[newTransactionId] = LockedToken({
            transactionId: newTransactionId,
            sender: msg.sender,
            recipient: _recipient,
            tokenAddress : 0x0000000000000000000000000000000000000000,
            amount: msg.value,
            claimed: false,
            approved: false,
            approvalAddress : _approvers,
            date : _date,
            filePath : _filePath,
            _type : "coin"
        });
        transactionIdCounter++;
        emit TokenLocked(newTransactionId, msg.sender, _recipient, 0x0000000000000000000000000000000000000000, msg.value, _approvers);
    }

    function getContractBNBBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function lockTokens(address _recipient, address _tokenAddress, uint256 _amount, address _approvers, string memory _date, string memory _filePath) external {        
        require(_recipient != address(0), "Invalid recipient address");
        require(_approvers != address(0), "Invalid recipient address");
        require(_tokenAddress != address(0), "Invalid token address");
        require(_amount > 0, "Amount must be greater than zero");
        IERC20(_tokenAddress).approve(address(this), _amount );
        IERC20(_tokenAddress).transferFrom(msg.sender, address(this), _amount );
        uint256 newTransactionId = transactionIdCounter;
        lockedTokens[newTransactionId] = LockedToken({
            transactionId: newTransactionId,
            sender: msg.sender,
            recipient: _recipient,
            tokenAddress: _tokenAddress,
            amount: _amount,
            claimed: false,
            approved: false,
            approvalAddress : _approvers,
            date : _date,
            filePath : _filePath,
            _type : "token"
        });
        transactionIdCounter++;
        emit TokenLocked(newTransactionId, msg.sender, _recipient, _tokenAddress, _amount, _approvers);
    }

    function approveTransaction(uint256 _transactionId) external nonReentrant{
        require(_transactionId < transactionIdCounter, "Invalid transaction ID");
        require(lockedTokens[_transactionId].amount > 0, "Zero amount can not be approve");
        require(lockedTokens[_transactionId].approvalAddress == msg.sender , "Only approved addresses can call this function");
        require(!lockedTokens[_transactionId].claimed, "Transaction already claimed");
        lockedTokens[_transactionId].approved = true;
        emit TransactionApproved(_transactionId, true);
        claimTransaction(_transactionId);
    }

    function claimTransaction(uint256 _transactionId) internal returns(bool){
        require(lockedTokens[_transactionId].approved, "Transaction not approved");
        uint256 balance = lockedTokens[_transactionId].amount;
        lockedTokens[_transactionId].amount = 0; 
        lockedTokens[_transactionId].claimed = true;
        if( keccak256(abi.encodePacked(lockedTokens[_transactionId]._type)) == keccak256(abi.encodePacked("token")) ){
            require( IERC20(lockedTokens[_transactionId].tokenAddress).transferFrom(address(this),lockedTokens[_transactionId].recipient, balance), "Token transfer failed");
        } else {
            payable(lockedTokens[_transactionId].recipient).transfer(balance);
        }
        emit TokensClaimed(_transactionId, lockedTokens[_transactionId].recipient, balance);
        return true;
    }

    function getLockedTransaction(uint256 _transactionId) external view returns (LockedToken memory) {
        require(_transactionId < transactionIdCounter, "Invalid transaction ID");
        return lockedTokens[_transactionId];
    }

    function getBalance(address _tokenAddress) external view returns(uint256){
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function rejectTransaction(uint256 _transactionId) external nonReentrant{
        require(lockedTokens[_transactionId].approvalAddress == msg.sender, "Only approved addresses can call this function");
        require(_transactionId < transactionIdCounter, "Invalid transaction ID");
        require(!lockedTokens[_transactionId].claimed, "Tokens already claimed");
        require(lockedTokens[_transactionId].amount > 0, "Zero amount can not be approve");
        lockedTokens[_transactionId].approved = true;
        uint256 balance = lockedTokens[_transactionId].amount;
        lockedTokens[_transactionId].amount = 0; 
        lockedTokens[_transactionId].claimed = true;
        if( keccak256(abi.encodePacked(lockedTokens[_transactionId]._type)) == keccak256(abi.encodePacked("token")) ){
            require( IERC20(lockedTokens[_transactionId].tokenAddress).transferFrom(address(this),lockedTokens[_transactionId].sender, balance), "Token transfer failed");
        } else {
            payable(lockedTokens[_transactionId].sender).transfer(balance);
        }
        emit TokensClaimed(_transactionId, lockedTokens[_transactionId].sender, balance);
    }

    function revertTrasaction(uint256 _transactionId) external onlyOwner nonReentrant{
        require(_transactionId < transactionIdCounter, "Invalid transaction ID");
        require(!lockedTokens[_transactionId].claimed, "Tokens already claimed");
        require(lockedTokens[_transactionId].amount > 0, "Zero amount can not be approve");
        lockedTokens[_transactionId].approved = true;
        uint256 balance = lockedTokens[_transactionId].amount;
        lockedTokens[_transactionId].amount = 0; 
        lockedTokens[_transactionId].claimed = true;
        if( keccak256(abi.encodePacked(lockedTokens[_transactionId]._type)) == keccak256(abi.encodePacked("token")) ){
            require( IERC20(lockedTokens[_transactionId].tokenAddress).transferFrom(address(this),lockedTokens[_transactionId].sender, balance), "Token transfer failed");
        } else {
            payable(lockedTokens[_transactionId].sender).transfer(balance);
        }
        emit TokensClaimed(_transactionId, lockedTokens[_transactionId].sender, balance);
    }
    receive() external payable {}
    fallback() external payable {}
}
