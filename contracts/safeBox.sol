pragma solidity ^0.8.7;

contract safeBox {
    mapping(string => myContract) contracts;

    struct myContract {
        string safeBoxId;
        string files;
        string name;
        string Date;
        address owner;
        address[] Approver;
        string status;
    }

    function addSafeBox(string memory safeBoxId, string memory files, string memory name, string memory Date, address owner, address[] memory Approver, string memory status) public {
        contracts[safeBoxId] = myContract(
            safeBoxId,
            files,
            name,
            Date,
            owner,
            Approver,
            status
        );
    }

    function getSafeBox(string memory safeBoxId)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            address,
            address[] memory,
            string memory
        )
    {
        return (
            contracts[safeBoxId].files,
            contracts[safeBoxId].name,
            contracts[safeBoxId].Date,
            contracts[safeBoxId].owner,
            contracts[safeBoxId].Approver,
            contracts[safeBoxId].status
        );
    }

    function updateSafeBox(
        string memory safeBoxId,
        string memory _status
    ) public {
        contracts[safeBoxId].status = _status;
    }
}