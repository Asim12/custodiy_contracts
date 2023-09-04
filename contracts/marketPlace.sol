// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract marketPlace{
    address public contractOwner;
    uint256 private orderId = 1;
    struct order { 
        string storeId;
        address buyerAddress;
        address sellerAddress;
        string [] productId;
        uint256 totalAmount;
        string order_id;
        address approvalAddress;
        string approvalStatus;   
    }
    mapping(uint256 => order) public orders;
    event createOrderEvent(string indexed storeId, address indexed SellerAddress, string [] productId, uint256 totalAmount, string indexed order_id, address approvalAddress, string approvalStatus);
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

    function createOrder(string memory _storeId, address _sellerAddress, string [] memory _productId, uint256 _totalAmount, string memory _order_id, address _approvalAddress, string memory _approvalStatus) external {
        require(_sellerAddress != address(0), "Seller address can not be empty");
        require(_totalAmount > 0 , "Amount can not be zero");
        orders[orderId].storeId = _storeId;
        orders[orderId].buyerAddress = msg.sender;
        orders[orderId].productId = _productId;
        orders[orderId].totalAmount = _totalAmount;
        orders[orderId].order_id = _order_id;
        orders[orderId].sellerAddress = _sellerAddress;
        orders[orderId].approvalAddress = _approvalAddress;
        orders[orderId].approvalStatus = _approvalStatus;
        orderId++;
        emit createOrderEvent(_storeId, _sellerAddress, _productId, _totalAmount, _order_id, _approvalAddress, _approvalStatus);
    }

    function approveOrder(uint256 _orderId) external {
        require(orders[_orderId].approvalAddress == msg.sender, "You can not approve this transaction");
        require(_orderId < orderId, "Order id is not valid");
        require(keccak256(abi.encodePacked(orders[_orderId].approvalStatus)) == keccak256(abi.encodePacked("pending")), "Transaction is already approved");
        orders[_orderId].approvalStatus = "approved";
    }

    function getOrderId() public view returns(uint256){
        return (orderId -1);
    }

    function rejectOrder(uint256 _orderId) external{
        require(orders[_orderId].approvalAddress == msg.sender, "You can not approve this transaction");
        require(keccak256(abi.encodePacked(orders[_orderId].approvalStatus)) != keccak256(abi.encodePacked("rejected")), "Transaction is already rejected");
        require(keccak256(abi.encodePacked(orders[_orderId].approvalStatus)) == keccak256(abi.encodePacked("pending")), "Transaction is already approved you can not reject this");
        require(_orderId < orderId, "Order id is not valid");
        orders[_orderId].approvalStatus = "rejected";
    }

    function rejectOrderAdmin(uint256 _orderId) external onlyOwner{
        require(keccak256(abi.encodePacked(orders[_orderId].approvalStatus)) != keccak256(abi.encodePacked("rejected")), string(abi.encodePacked("You can not reject this order because current status is ", orders[_orderId].approvalStatus )));
        require(_orderId < orderId, "Order id is not valid");
        orders[_orderId].approvalStatus = "rejected";
    }
}