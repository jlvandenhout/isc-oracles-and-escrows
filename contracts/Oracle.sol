// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Oracle is Ownable {
  enum Status {
    Pending,
    Accepted,
    Delivered
  }

  mapping(bytes32 => Status) parcels;

  constructor() Ownable(msg.sender) {}

  function request(bytes32 nonce) public view returns (bytes32) {
    return keccak256(abi.encode(msg.sender, nonce));
  }

  function set(bytes32 parcel, Status status) public onlyOwner {
    parcels[parcel] = status;
  }

  function get(bytes32 parcel) public view returns (uint) {
    return uint(parcels[parcel]);
  }
}
