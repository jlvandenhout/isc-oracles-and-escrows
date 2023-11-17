// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Oracle is Ownable {
  enum Status {
    Accepted,
    Delivered
  }

  Status[] parcels;

  constructor() Ownable(msg.sender) {}

  function add() public onlyOwner returns (uint) {
    parcels.push(Status.Accepted);
    return parcels.length - 1;
  }

  function set(uint parcel, Status status) public onlyOwner {
    parcels[parcel] = status;
  }

  function has(uint parcel) public view returns (bool) {
    return parcel < parcels.length;
  }

  function get(uint parcel) public view returns (Status) {
    return parcels[parcel];
  }
}
